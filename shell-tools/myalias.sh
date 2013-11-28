source $TOOL_HOME/tools/libs.sh;
#source $TOOL_HOME/tools/bash_completion/bash_completion;
source "$TOOL_HOME/download.sh";

alias mdfmyalias="gedit $TOOL_HOME/myalias.sh &"
alias opjava="nautilus $JAVA_DIR";

function gitpatch() {
      eval 'if [ $JIRA_NUMBER == "TEMP" ]; then export JIRA_NUMBER="$(date -u +%h%M)"; fi &&
               echo "Tao file diff cho issue: $JIRA_NUMBER Va save xuong thu muc: $PATCH_FILES" &&
         git format-patch $*> $PATCH_FILES/$(date -u +%Y%m%d)-$JIRA_NUMBER.patch'
}

function gitpdiff() {
      eval 'if [ $JIRA_NUMBER == "TEMP" ]; then export JIRA_NUMBER="$(date -u +%h%M)"; fi &&
               echo "Tao file diff cho issue: $JIRA_NUMBER Va save xuong thu muc: $PATCH_FILES" &&
         git diff $*> $PATCH_FILES/$(date -u +%Y%m%d)-$JIRA_NUMBER.patch'
}

alias mvneclipse="mvn eclipse:eclipse"
alias mvnclean="mvn eclipse:clean"

alias svndiff="svn diff > tem.patch && sleep 1s && mdf tem.patch && sleep 1s && rm tem.patch";


function getdb() {
  dbuser="root";
  dbpass="root";
  dbname="$1";
  action="$2";
  exist="false";
  DBS=`mysql -u$dbuser -p$dbpass -Bse 'show databases'| egrep -v 'information_schema|mysql'`
  for db in $DBS; do
    if [ "$db" == "$dbname" ]; then
      exist="true";
      if [ "$action" == "rm" ]; then
          mysqladmin -u$dbuser -p$dbpass drop $dbname;
          mysqladmin -u$dbuser -p$dbpass create $dbname;
      fi
    fi
  done
  if [ "$exist" == "false" ]; then 
      mysqladmin -u$dbuser -p$dbpass create $dbname;
  fi
}

function runbysql() {
  action="$1"
  data="plf_mic_jcr";
  user="plf_mic_idm";
  if [ -n "$2" ] && [ -n "$3" ]; then
    data="$2";
    user="$3";
  fi
  
  Opwd="$PWD";
  
  getTomcatDir;

  mv $EXO_TOMCAT/conf/server.xml $EXO_TOMCAT/conf/server_b.xml;
  cp $EXO_TOMCAT/conf/server-mysql.xml $EXO_TOMCAT/conf/server.xml;
  cd $EXO_TOMCAT/conf/;
  if [ -e "$TOOL_HOME/libs/server.xml" ]; then
    INFO "cp $TOOL_HOME/libs/server.xml $EXO_TOMCAT/conf/";
    cp $TOOL_HOME/libs/server.xml $EXO_TOMCAT/conf/;
    eval "findsed 'plf_mic_jcr' '$data' 'server.xml'";
    eval "findsed 'plf_mic_idm' '$user' 'server.xml'";
  else 
    eval "findsed 'plf' '$data' 'server.xml'";
    eval "findsed 'plf' '$user' 'server.xml'";
  fi
  if [ "$action" == "rm" ]; then
    cd ../
    rm -rf gatein/data/*
  fi

  cd $Opwd;
  eval "getdb $data $action && getdb $user $action && runtomcat" ;
}

function gedit() {
	eval "geany $* &";
}

alias sourcedl="source $TOOL_HOME/tools/download.sh"
alias mdfdl="gedit $TOOL_HOME/tools/download.sh &"

function mdf_() { 
  eval "gedit $1 &"; 
}

alias mdf="mdf_";

alias gitlog='git log > /tmp/temp.log && sleep 1 && gedit /tmp/temp.log &';

alias gitconf="gedit .git/config";
alias cdmygit="cd mygit/";


patchDiff="/tmp/my/tmp.patch";
function gitdiff() {
  git diff $*  > $patchDiff && sleep 2s && gedit $patchDiff;
}

if [ ! -e /tmp/my ]; then
	eval "mkdir -p -m 777 /tmp/my";
fi

PDate="$(date -u +%Y-%m-%d)";
FIRST="false";
if [ ! -e /tmp/my/$PDate.my ]; then
	eval "rm -rf /tmp/my/*";
	eval "echo '$PDate' > /tmp/my/$PDate.my";
	#eval "insync-kde &"
	FIRST="true";
fi


function gitpull () {
	if [ -n "$1" ]; then
		git pull $*;
	else
		git pull --all;
	fi	
}

function readEnter() {
	read -n100 -p "Please input the $1: " keypress;
	echo "$keypress";
}

function gitnewfix() {
	local issue="";
	local vers="";
	if [ -n "$1" ]; then
		issue="$1";
		if [ -n "$2" ]; then
			vers="$2";
		else
			vers=$(readEnter "version");
		fi
	else
		issue=$(readEnter "issue");
		vers=$(readEnter "version");
	fi
	
	if [ -n "$issue" ] && [ -n "$vers" ]; then 
		INFO "git checkout -b \"fix/$vers/$issue\" \"platform/stable/$vers\""
		git checkout -b "fix/$vers/$issue" "platform/stable/$vers"
	fi
	
}

function renameByindex() {
  type=$1;
  pwd_=$PWD;
  i=0;
  for X in `ls *.$type --color=no`; 
    do
      if [ -e "$pwd_/$X" ]; then
        echo "mv $X $i.$type";
        eval "mv $X $i.$type"; 
        ((i = i + 1));
      fi
 done
  
}

ISSUE="";

function setissuename() {
  local issNb=$1;
  ISSUE="$(date -u +%Y%m%d)-$issNb.patch";
  echo $ISSUE;
}

alias gitadd="git add";
alias gitst="git st";
alias gitbr="git br";
alias gitlg="git lg";

function tomcatinject() {
	getTomcatDir;
	INFO "copy $TOOL_HOME/libs/injection-forum-4.1.x-SNAPSHOT.jar to $EXO_TOMCAT/lib/";
	cp $TOOL_HOME/libs/injection-forum-4.1.x-SNAPSHOT.jar $EXO_TOMCAT/lib/
}

function sendtoplftomcat() {
	getTomcatDir;
	eval "sendtotomcat $EXO_TOMCAT $*";	
}

alias tomcatsend="killTomcat && sendtoplftomcat"

function mvnnoclean() {
  eval "killTomcat && mvninstall -Dskip-archive $* && tomcatinject";
}

function tomcatbuild() {
	eval "mvninstall $* && killTomcat && sendtoplftomcat"
}

function zzzzcm() {
	eval "XX=$PWD && cd $EXO_TOMCAT/webapps/ && find -maxdepth 1 -mindepth 1 -type d -exec rm -rf {} \;";
}

function updateStyle() {
   tcDir="$1";
   INFO "Find all file *.war";
   wars=$(find -name *.war)
   temp="";
   for X in ${wars[@]}
    do
    temp="${X/.*target\//}";
    
    dirfolder="${X/$temp/}";
    dirfolder="${dirfolder/\.\/}";
    cssdirfolder="$dirfolder";

    dirfolder="${dirfolder/target\//}";
    dirfolder="${dirfolder}src/main/webapp";
    y="$(expr match "$temp" '.*\(/\)')";
    if [ "$y" == "" ]; then
      folder="${temp/.war/}"
      INFO "Remove old folder $folder/skin"
      rm -rf $tcDir/webapps/$folder/skin/*
      INFO "Copy files ${cssdirfolder}${folder}/skin into $tcDir/webapps/$folder/"
      eval "cp -rf ${cssdirfolder}${folder}/skin $tcDir/webapps/$folder/"

      INFO "Copy files ${dirfolder}/templates into $tcDir/webapps/$folder/"
      eval "cp -rf ${dirfolder}/templates $tcDir/webapps/$folder/"

      INFO "Copy files ${dirfolder}/javascript into $tcDir/webapps/$folder/"
      eval "cp -rf ${dirfolder}/javascript $tcDir/webapps/$folder/"
    fi
   done
}

function sendinject() {
	getTomcatDir;
	if [ $(expr match $EXO_TOMCAT "$PWD") -gt 0 ]; then
		INFO "Run tomcatinject...";
		eval "tomcatinject";
		INFO "cp $TOOL_HOME/configuration.properties $EXO_TOMCAT/gatein/conf/";
		cp "$TOOL_HOME/configuration.properties" "$EXO_TOMCAT/gatein/conf/"
		
		if [ -e "$TOOL_HOME/libs/crash.war" ]; then
			INFO "cp $TOOL_HOME/libs/crash.war $EXO_TOMCAT/webapps/";
			cp "$TOOL_HOME/libs/crash.war" "$EXO_TOMCAT/webapps/"
		fi

		if [ -e "$TOOL_HOME/libs/mysql-connector-java-5.1.13.jar" ]; then
			INFO "cp $TOOL_HOME/libs/mysql-connector-java-5.1.13.jar $EXO_TOMCAT/lib/";
			cp "$TOOL_HOME/libs/mysql-connector-java-5.1.13.jar" "$EXO_TOMCAT/lib/"
		fi
	fi
}

function applyless() {
	getTomcatDir;
	eval "updateStyle $EXO_TOMCAT"
}

function mvninstall(){
	isTomcat="";
	callback="";
	test="-Dmaven.test.skip=true";
	debug="";
	other="";
	command_="mvn clean install";
	if [ $(containText "tomcat" "$PWD") == "OK" ]; then 
		isTomcat="-Dskip-archive";
		callback=" && sendinject";
		test="";
	fi

	if [ $(containText "commons-extension-webapp" "$PWD") == "OK" ]; then 
		 eval "sed -i -e 's/<\/dependencies>/<\/dependencies><build><finalName>commons-extension<\/finalName><\/build>/g' $PWD/pom.xml";
		 callback="$callback && git co pom.xml";
	fi

	for arg  in "$@" 
    do
     arg="${arg/--/}" 
     arg="${arg//./}"
		 if [ "$arg" == "test=true" ] || [ "$arg" == "test" ]; then
				test="";
		 elif [ "$arg" == "test=false" ]; then
				test="-Dmaven.test.skip=true";
		 elif [ "$arg" == "debug" ] || [ "$arg" == "debug=true" ]; then 
				debug=" -Dmaven.surefire.debug=true";
		 elif [ "$arg" == "eclipse" ]; then 
				command_="mvn eclipse:eclipse";
		 elif [ "$arg" == "eclean" ]; then 
				command_="mvn eclipse:clean";
		 elif [ "$arg" == "clean" ]; then 
				command_="mvn clean";
		 elif [ $(containText "class=" "$arg") == "OK" ]; then 
				test=" -Dtest=${arg/class=/}";
		 else 
				other="$other $arg";
		 fi

   done


	INFO "$command_ $isTomcat $test$debug -Pexo-private $T2C $other $callback";
  eval "$command_ $isTomcat $test$debug -Pexo-private $T2C $other $callback";
}

function buildSkin() {
	eval "mvninstall $* && applyless";
}
#lessc styles.less > styles.css

#'s/$rg/$by/g'


function mouse(){
  #xinput --set-prop "PS/2 Generic Mouse" "Device Enabled" 1
  local INPUT=`xinput list | grep 'PS/2' | sed -e 's/.*id=//g' |  awk '{print $1}'`
  xinput --set-prop "$INPUT" "Device Enabled" 1
}

function mousedie() {
  #xinput --set-prop "PS/2 Generic Mouse" "Device Enabled" 0
  local INPUT=`xinput list | grep 'PS/2' | sed -e 's/.*id=//g' |  awk '{print $1}'`
  xinput --set-prop "$INPUT" "Device Enabled" 0
}

mousedie;

function JDBC() {
	grep --color=never --after-context=0 --before-context=1 'JDBC queries was executed but the maximum is' test.txt | sed -e 's/--.*//g'> ntest.txt	
}

alias bcommon='cd commons-api/ && tomcatbuild -o && cd ../ && cd commons-component-common/ && tomcatbuild -o && cd ..';


function mvntest() {
	for arg  in "$@" 
  do
  	INFO "mvn install  -Pexo-private -Dtest=$arg";
		eval "mvn install  -Pexo-private -Dtest=$arg";
  done
}

PROJECTS="commons/ social/ forum/ platform/ integration/"

function ball() {
	cm="feature/stabilization";

	if [ -n "$1" ]; then
		cm="$1";
	fi
	INFO "cmprojectall 'c$PROJECTS platform-private-distributions/plf-enterprise-tomcat-standalone/' 'git co $cm && git pull --all && mvninstall'";
	eval "cmprojectall '$PROJECTS platform-private-distributions/plf-enterprise-tomcat-standalone/' 'git co $cm && git pull --all && mvninstall'";	
}

_mvninstall() {
	local cur="${COMP_WORDS[COMP_CWORD]}";
  local opts="eclipse clean eclean test=true debug class= -U -o dependency:build-classpath dependency:sources dependency:analyze-report dependency:analyze dependency:tree dependency:unpack dependency:resolve dependency:copy dependency:analyze-only dependency:resolve-plugins ${COMPREPLY[@]}";
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_mvninstall" -o "default" "mvninstall"

_gitdiff() {
	local cur="${COMP_WORDS[COMP_CWORD]}";
  local opts="HEAD master HEAD~ origin/HEAD ${COMPREPLY[@]}";
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_gitdiff" -o "default" "gitdiff"

function A() {
  mkdir "$1" && cd "$1" && echo '' > "$1.sh" && gedit "$1.sh";
}
