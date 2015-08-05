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
  toCate="0";
  forum="0";
  toForum="0"
  topic="0";
  toTopic="0";
  post="0";
  fromUser="1";
  to="1";
  
  space="0";
  membership="0";
  activity="0";
  mentioner="0";
  relationship="0";
  
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
  INFO "users=$users category=$category forum=$forum toCate=$toCate topic=$(($topic*delta)) toForum=$toForum post=$(($post*delta)) toTopic=$toTopic rest=$rest";
  
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

  if [ ! "$users" == "0" ]; then
    echo "forumInject $login -t forumProfile -n $nU -r $rest -p  'number=$users&prefix=user'" && 
    eval "forumInject $login -t forumProfile -n $nU -r $rest -p  'number=$users&prefix=user'" && sleep 2s
  fi

  if [ ! "$category" == "0" ]; then
    echo "forumInject $login -t forumCategory -n $nC -r $rest -p  'number=$category&fromUser=$from&toUser=$to&userPrefix=user&catPrefix=cate_inject'" && 
    eval "forumInject $login -t forumCategory -n $nC -r $rest -p  'number=$category&fromUser=$from&toUser=$to&userPrefix=user&catPrefix=cate_inject'" && sleep 2s
  fi

  if [ ! "$forum" == "0" ]; then  
    echo "forumInject $login -t forumForum -n $nF -r $rest -p  'number=$forum&toCat=$toCate&catPrefix=cate_inject&forumPrefix=forum_inject'" &&
    eval "forumInject $login -t forumForum -n $nF -r $rest -p  'number=$forum&toCat=$toCate&catPrefix=cate_inject&forumPrefix=forum_inject'" && sleep 2s
  fi

  if [ ! "$topic" == "0" ]; then  
    echo "forumInject $login -t forumTopic -n $nT -r $rest -p  'number=$topic&topicPrefix=topic_inject&fromUser=$from&toUser=$to&userPrefix=user&toForum=$toForum&forumPrefix=forum_inject'" &&
    eval "forumInject $login -t forumTopic -n $nT -r $rest -p  'number=$topic&topicPrefix=topic_inject&fromUser=$from&toUser=$to&userPrefix=user&toForum=$toForum&forumPrefix=forum_inject'" && sleep 2s
  fi

  if [ ! "$post" == "0" ]; then  
    echo "forumInject $login -t forumPost -n $nP -r $rest -p  'number=$post&postPrefix=post_inject&fromUser=$from&toUser=$to&userPrefix=user&toTopic=$toTopic&topicPrefix=topic_inject'" &&
    eval "forumInject $login -t forumPost -n $nP -r $rest -p  'number=$post&postPrefix=post_inject&fromUser=$from&toUser=$to&userPrefix=user&toTopic=$toTopic&topicPrefix=topic_inject'";
  fi
  
  
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
  prefix="user";
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
  	echo "forumInject $login -t forumProfile -r $rest -p 'number=$users&prefix=$prefix'"; 
  	eval "forumInject $login -t forumProfile -r $rest -p 'number=$users&prefix=$prefix'";
  fi 
  
}

function injection_identity() {
  eval "injection_user $*"
}

##################### NEW #######################################
injection_help() {
  INFO " ALL COMMANDS ";
  INFO "injection_user users=10 prefix=user";
  INFO "injection category=1 forum=1 toCate=0 topic=1 toForum=1 post=1 toTopic=0 users=0 from=10 to=20";
  INFO 'injection_cate numberCate=$1';
  INFO 'injection_forum numberForum=$1 fromCate=$2 toCate=$3';
  INFO 'injection_topic numberTopic=$1 maxUser=$2 fromForum=$3 toForum=$4 fromUser=$5';
  INFO 'injection_post numberPost=$1 maxUser=$2 fromTopic=$3 toTopic=$4 fromUser=$5';
  INFO '';
  
}

# injection_cate numberCate=$1
CATE="0";
function injection_cate() {
  CATE=$1;
  if [ -n "$CATE" ]; then
    INFO "injection category=$CATE forum=0 toCate=0 topic=0 toForum=0 post=0 toTopic=0 users=0 from=0 to=0";
    eval "injection category=$CATE forum=0 toCate=0 topic=0 toForum=0 post=0 toTopic=0 users=0 from=0 to=0";
  fi
}

# injection_forum numberForum=$1 fromCate=$2 toCate=$3
FORUM="0";
function injection_forum() {
  FORUM=$1;
  from=0;
  to=$CATE;
  N_FOR=0;
  if [ -n "$2" ]; then
    from=$2;
  fi
  if [ -n "$3" ]; then
    to=$3;
  fi 
  INFO "injection_forum numberForum=$FORUM fromCate=$from toCate=$to"
  cm="echo ''";
  if [ -n "$FORUM" ]; then
    for ((i=$from; i < $to ; i++))
      do
      #INFO "injection category=0 forum=$FORUM toCate=$i topic=0 toForum=0 post=0 toTopic=0 users=0 from=0 to=0";
      B_N=$N_FOR;
      N_FOR=$((FORUM * (i + 1)));
      #INFO "From $B_N to $N_FOR";
      cm="$cm && injection category=0 forum=$FORUM toCate=$i topic=0 toForum=0 post=0 toTopic=0 users=0 from=0 to=0";
    done
    INFO "$cm";
    eval "$cm";
  fi
}
function defaultForumData() {
  eval "injection_user 'users=demo,mary,john' && injection_user 'users=21' && injection_cate '5' && injection_forum 5 0 5 && injection_topic 10 20 0 10 0 && injection_post 10 20 0 30 0";
}

# injection_topic numberTopic=$1 maxUser=$2 fromForum=$3 toForum=$4 fromUser=$5
TOPIC="0";
function injection_topic() {
  TOPIC=$1;
  M_User=$2;
  N_TOP=0;
  F_U=0;
  to=$TOPIC;

  if [ -n "$5" ]; then
    F_U=$5;
    to=$((TOPIC + F_U));
  fi

  from=$F_U;
  
  FR=0;
  TO=$N_FOR;

  if [ -n "$3" ]; then 
    FR=$3;
  fi
  if [ -n "$4" ]; then 
    TO=$4;
  fi
  
  if [ -n "$TOPIC" ]; then
    for ((i=$FR; i < $TO ; i++))
      do
      INFO "injection category=0 forum=0 toCate=0 topic=1 toForum=$i post=0 toTopic=0 users=0 from=$from to=$to";
      eval "injection category=0 forum=0 toCate=0 topic=1 toForum=$i post=0 toTopic=0 users=0 from=$from to=$to";
      from=$((to + 1));
      to=$((from + TOPIC));
      
      B_N=$N_TOP;
      N_TOP=$((TOPIC * (i + 1)));
      INFO "From $B_N to $N_TOP";
      if [ -n "$M_User" ] && [ "$((to > M_User))" == "1" ]; then
        from=$F_U;
        to=$((from + TOPIC));
      fi
    done
  
  fi
}

_injection_topic ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="1syntax: numberTopic_maxUser_fromForum_toForum_fromUser"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_injection_topic" -o "default" "injection_topic"


# injection_post numberPost=$1 maxUser=$2 fromTopic=$3 toTopic=$4 fromUser=$5
POST=0;
function injection_post() {
  POST=$1;
  M_User=$2;
  N_POST=0;
  to=$POST;
  F_U=0;
  if [ -n "$5" ]; then
    F_U=$5;
    to=$((POST + F_U));
  fi
  from=$F_U;

  FR=0;
  TO=$N_TOP;

  if [ -n "$3" ]; then 
    FR=$3;
  fi
  if [ -n "$4" ]; then 
    TO=$4;
  fi

  if [ -n "$POST" ]; then
    for ((i=$FR; i < $TO; i++))
      do
      INFO "injection category=0 forum=0 toCate=0 topic=0 toForum=0 post=1 toTopic=$i users=0 from=$from to=$to";
      eval "injection category=0 forum=0 toCate=0 topic=0 toForum=0 post=1 toTopic=$i users=0 from=$from to=$to";
      from=$((to + 1));
      to=$((from + POST));

      B_N=$N_POST;
      N_POST=$((POST * (i + 1)));
      INFO "From $B_N to $N_POST";
      if [ -n "$M_User" ] && [ "$((to > M_User))" == "1" ]; then
        from=$F_U;
        to=$((from + POST));
      fi
    done
    INFO "All posts: $N_POST"
  fi
}

#localhost:8080/rest/private/bench/inject/space?number=20&userPrefix=user&fromUser=0&toUser=1&spacePrefix=space_inject
function injection_space() {
	for arg  in "$@" 
	  do
		x=`expr index "$arg" "="`;
		if [ $x -gt 0 ]; then
		  eval "$arg";
		fi
	 done
   if [ ! -n "$userPrefix" ]; then
      userPrefix="user";
   fi
   if [ ! -n "$spacePrefix" ]; then
      spacePrefix="space_inject";
   fi   
   if [ ! -n "$from" ]; then
      from="0";
   fi   
   if [ ! -n "$to" ]; then
      to="1";
   fi   
	 INFO "forumInject -t space -p 'number=$number&userPrefix=$userPrefix&fromUser=$from&toUser=$to&spacePrefix=$spacePrefix'";
}
_injection_space ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="number=20 userPrefix=user from=0 to=1 spacePrefix=space_inject"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_injection_space" -o "default" "injection_space"
  
### By document
#localhost:8080/rest/private/bench/inject/relationship?number=20&prefix=user&fromUser=0&toUser=1
## By number on each user
#localhost:8080/rest/private/bench/inject/relationship?number=20&prefix=user&fromUser=0&toUser=1&bynumber=true
## By source user
#localhost:8080/rest/private/bench/inject/relationship?number=20&srcUser=root
function injection_relationship() {
	number="0";
	prefix="";
	fromUser="0";
	toUser="0";
	bynumber="false";
	srcUser="";
	help="false";
	for arg  in "$@" 
	  do
		x=`expr index "$arg" "="`;
		if [ $x -gt 0 ]; then
		  eval "$arg";
		fi
		if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
		  help="true";
		fi
	 done
	 if [ $help == "true" ] || [ ! -n "$1" ]; then
		INFO "============ HELP ===========";
		INFO " Example: number=20 srcUser=root prefix=user from=0 to=10"
		INFO " By document"
		INFO "localhost:8080/rest/private/bench/inject/relationship?number=20&prefix=user&fromUser=0&toUser=10"
		INFO " By number on each user"
		INFO "localhost:8080/rest/private/bench/inject/relationship?number=20&prefix=user&fromUser=0&toUser=1&bynumber=true"
		INFO " By source user"
		INFO "localhost:8080/rest/private/bench/inject/relationship?number=20&srcUser=root&prefix=user&fromUser=$from&toUser=$to"
	 else
		eval "forumInject -t relationship -p 'number=$number&prefix=$prefix&fromUser=$from&toUser=$to&bynumber=$bynumber&srcUser=$srcUser'";
	 fi
}
_injection_relationship ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="number=20 srcUser=root prefix=user from=0 to=1 -h --help"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_injection_relationship" -o "default" "injection_relationship"



##################### END NEW #######################################

_injection ()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="users=10 category=5 forum=10 toCate=0 topic=10 toForum=0 post=20 toTopic=0 from=1 to=2 rest=rest login=root:gtn"
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
