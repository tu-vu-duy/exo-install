#!/bin/bash
# Argument = -t datatype [-n numberOfexecution] [-h server] -p "getDataParameter"

usage()
{
cat << EOF
  usage: $0 -t datatype [-n numberOfexecution] [-h server] -p "getDataParameter"

  This script run the data injection with datatype and all parameter

  OPTIONS:
     -h      Server ( default http://localhost:8080)
     -t      Injection data type ( forumProfile | faqProfile | forumCategory | forumForum | ... | userInject )
     -n      Loop count number
     -u      Login user infomation ( root:gtn )
     -p      Get parameter ( http://int.exoplatform.org/portal/intranet/wiki/group/spaces/engineering/KS_Forum_Data_Injectors)
     -r      Rest name, default is rest
     -v      Verbose

  Example:
    - Inject 100 profile for 100 times with prefix abc.user
      forumInject -t forumProfile -n 10 -r "rest-ksdemo" -p  "number=10&prefix=abc.user"
    - Default inject is run function: injection

EOF
}
SERVER_INJECT="http://localhost:8080"
REST_INJECT="rest"
USER_INJECT="root";
PASS_INJECT="gtn";
USER="$USER_INJECT:$PASS_INJECT";
function forumInject() {
  TYPE="";
  GETPARAM="";
  LOOP=1;
  OPTSTRING="h:t:n:p:r:u:";
  while getopts ${OPTSTRING} OPTION
  do
       case $OPTION in
           h)
               SERVER_INJECT=$OPTARG
               ;;
           t)
               TYPE=$OPTARG
               ;;
           n)
               LOOP=$OPTARG
               ;;
           p) 
               GETPARAM=$OPTARG
               ;;
           r) 
               REST_INJECT=$OPTARG
               ;;
           u) 
               USER=$OPTARG
               ;;
           ?)
               usage
               ;; 
       esac
  done
  # unset getopts variables
  shift $(( OPTIND - 1 ));
  unset OPTSTRING;
  unset OPTIND;
  unset OPTARG;
  
  # Run inject
  if [ -n "$TYPE" ];  then
    for (( LOOPCOUNT=1; LOOPCOUNT<=$LOOP; LOOPCOUNT++ ))
    do
      echo "Injection $TYPE ($LOOPCOUNT / $LOOP)";
      echo "curl -u $USER -s -v $SERVER_INJECT/$REST_INJECT/private/bench/inject/${TYPE}?$GETPARAM";
      eval "time curl -u $USER -s -v '$SERVER_INJECT/$REST_INJECT/private/bench/inject/${TYPE}?$GETPARAM'";
    done
  else 
    usage;
  fi
}

function getN() {
  input=$1;
  if [ -n "$input" ]; then
    N=$(($input/50));
    if [ "$N" != "0" ]; then
      echo $N;
    else 
      echo 1;
    fi
  else
    echo 1;
  fi
}

function getNumber() {
  input=$1;
  if [ -n "$input" ]; then
    Nb=$(($input%50));
    if [ "$Nb" != "0" ]; then
      echo $Nb;
    else 
      echo "0";
    fi
  else
    echo "10";
  fi
}

function injection_server() {
	login="";
	server=""

	for arg  in "$@" 
  do
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      eval "$arg";
    fi
  done
  
 	if [ -n "$login" ]; then 
		login="${login/login=/}";
		USER="$login";
	fi

 	if [ -n "$server" ]; then 
		server="${server/server=/}";
		SERVER_INJECT="$server";
	fi  
	INFO "login=$USER server=$SERVER_INJECT"
}

function injection() {
  users="0";
  category="0";
  forum="0";
  topic="0";
  post="0";
  from="1";
  to="1";
  rest="rest";
  login="";
  for arg  in "$@" 
  do
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      eval "$arg";
    fi
  done
  delta=$(($to - $from + 1));
  INFO "users=$users category=$(($category*delta)) forum=$forum topic=$(($topic*delta)) post=$(($post*delta)) rest=$rest";
  
  nU=`getN $users`;
  users=`getNumber $users`;
  
  nC=`getN $category`;
  category=`getNumber $category`;
  
  nF=`getN $forum`;
  forum=`getNumber $forum`;
  
  nT=`getN $topic`;
  topic=`getNumber $topic`;
  
  nP=`getN $post`;
  post=`getNumber $post`;

	if [ -n "$login" ]; then 
		login="-u $login";
	fi

  echo "forumInject $login -t forumProfile -n $nU -r $rest -p  'number=$users&prefix=user'" && 
  eval "forumInject $login -t forumProfile -n $nU -r $rest -p  'number=$users&prefix=user'" && sleep 2s &&

  echo "forumInject $login -t forumCategory -n $nC -r $rest -p  'number=$category&fromUser=$from&toUser=$to&userPrefix=user&catPrefix=cate_inject'" && 
  eval "forumInject $login -t forumCategory -n $nC -r $rest -p  'number=$category&fromUser=$from&toUser=$to&userPrefix=user&catPrefix=cate_inject'" && sleep 2s &&
  
  echo "forumInject $login -t forumForum -n $nF -r $rest -p  'number=$forum&toCat=1&catPrefix=cate_inject&forumPrefix=forum_inject'" &&
  eval "forumInject $login -t forumForum -n $nF -r $rest -p  'number=$forum&toCat=1&catPrefix=cate_inject&forumPrefix=forum_inject'" && sleep 2s &&
  
  echo "forumInject $login -t forumTopic -n $nT -r $rest -p  'number=$topic&topicPrefix=topic_inject&fromUser=$from&toUser=$to&userPrefix=user&toForum=1&forumPrefix=forum_inject'" &&
  eval "forumInject $login -t forumTopic -n $nT -r $rest -p  'number=$topic&topicPrefix=topic_inject&fromUser=$from&toUser=$to&userPrefix=user&toForum=1&forumPrefix=forum_inject'" && sleep 2s &&
  
  echo "forumInject $login -t forumPost -n $nP -r $rest -p  'number=$post&postPrefix=post_inject&fromUser=$from&toUser=$to&userPrefix=user&toTopic=1&topicPrefix=topic_inject'" &&
  eval "forumInject $login -t forumPost -n $nP -r $rest -p  'number=$post&postPrefix=post_inject&fromUser=$from&toUser=$to&userPrefix=user&toTopic=1&topicPrefix=topic_inject'";
  INFO "The end all.....";
}

function injection_answer() {
	lever="2";
  users="0";
  category="0";
  question="0";
  answer="0";
  comment="0";
  fromQues="1";
  toQues="1";
	login="";
  rest="rest";
  for arg  in "$@" 
  do
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      eval "$arg";
    fi
  done
  delta=$(($toQues - $fromQues + 1));
  INFO "users=$users category=$category lever=$lever question=$question answer=$(($answer*delta)) comment=$(($comment*delta)) rest=$rest";
  
  nU=`getN $users`;
  users=`getNumber $users`;
  
  nC=`getN $category`;
  category=`getNumber $category`;
  
  nQ=`getN $question`;
  question=`getNumber $question`;
  
  nA=`getN $answer`;
  answer=`getNumber $answer`;
  
  nC=`getN $comment`;
  comment=`getNumber $comment`;

	if [ -n "$login" ]; then 
		login="-u $login";
	fi

  echo "forumInject $login -t faqProfile -n $nU -r $rest -p  'number=$users&userPrefix=user'" && 
  eval "forumInject $login -t faqProfile -n $nU -r $rest -p  'number=$users&userPrefix=user'" && sleep 2s &&

  echo "forumInject $login -t faqCategory -n $nC -r $rest -p  'number=$category&lever=$lever&catPrefix=cate_inject'" && 
  eval "forumInject -t faqCategory -n $nC -r $rest -p  'number=$category&lever=$lever&catPrefix=cate_inject'" && sleep 2s &&
  
  echo "forumInject $login -t faqQuestion -n $nQ -r $rest -p  'number=$question&catPrefix=cate_inject&toCat=0&userPrefix=user&toUser=1&quesPrefix=ques_inject'" &&
  eval "forumInject -t faqQuestion -n $nQ -r $rest -p  'number=$question&catPrefix=cate_inject&toCat=0&userPrefix=user&toUser=1&quesPrefix=ques_inject'" && sleep 2s &&
  
  echo "forumInject $login -t faqAnswer -n $nA -r $rest -p  'number=$answer&fromQues=$fromQues&toQues=$toQues&quesPrefix=ques_inject&answerPrefix=answer_inject'" &&
  eval "forumInject $login -t faqAnswer -n $nA -r $rest -p  'number=$answer&fromQues=$fromQues&toQues=$toQues&quesPrefix=ques_inject&answerPrefix=answer_inject'" && sleep 2s &&
  
  echo "forumInject $login -t faqComment -n $nC -r $rest -p  'number=$comment&toQues=$toQues&quesPrefix=ques_inject&commentPrefix=comment_inject'" &&
  eval "forumInject $login -t faqComment -n $nC -r $rest -p  'number=$comment&toQues=$toQues&quesPrefix=ques_inject&commentPrefix=comment_inject'";
  INFO "The end all Answer Inject.....";
}

function isNumber() {
	echo "$1" | awk '$0 ~/[^0-9]/ { print "not" }';	
}

function injection_user() {
	users=$1;
	rest="rest";
	login="";
	type="n";
	for arg  in "$@" 
  do
    x=`expr index "$arg" "="`;
    echo $arg
    if [ $x -gt 0 ]; then
      eval "$arg";
    fi
  done

	if [ -n "$login" ]; then 
		login="-u $login";
	fi

  isNB=$(isNumber "$users");
  if [ "$isNB" == "not"  ]; then
  	users=${users// /_};
  	echo "forumInject $login -t userInject -r $rest -p 'users=$users&type=$type'"; 
  	eval "forumInject $login -t userInject -r $rest -p 'users=$users&type=$type'"
  else
  	echo "forumInject $login -t forumProfile -r $rest -p 'number=$users&prefix=user'"; 
  	eval "forumInject $login -t forumProfile -r $rest -p 'number=$users&prefix=user'";
  fi 
  
} 

_injection ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="users=10 category=5 forum=10 topic=10 post=20 from=1 to=2 rest=rest login=root:gtn"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_injection" -o "default" "injection"

_injection_answer ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="users=10 category=5 question=5 answer=5 comment=5 rest=rest fromQues=1 toQues=2 lever=2 login=root:gtn"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_injection_answer" -o "default" "injection_answer"


_injection_user ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="users=demo,mary,john login=root:gtn type=v"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
#philippe,franck,julien,binh,may,minh,hoa,thanh,tung,pham_duy,tan,ha,damien,cuong,ha,tran_mai,hieu,thuy,thien_nga,an,anh,bich,binh,cong,dieu,ha,hai,hai,hang,hau,huong,lam,loan,long,nghi,thu,thuy,trung,trung,tu,van,viet,vu,vu,anh,canh,thao,tuan,phuong_anh,nam,nam,hoang,chau,giang,ngoc,phong,son,thanh,tung,trong,marine,hanh,anh,ha,hoa,nhung,phuong,thanh,trang,tung,tu
complete -F "_injection_user" -o "default" "injection_user"


_injection_server ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="server=http://localhost:8080 login=root:gtn"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_injection_server" -o "default" "injection_server"
