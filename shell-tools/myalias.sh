if [ $(whoami) != "root" ]; then
   source "$TOOL_HOME/tools/libs.sh;"
fi
#source $TOOL_HOME/tools/bash_completion/bash_completion;
source "$TOOL_HOME/download.sh";

alias mdfmyalias="gedit $TOOL_HOME/myalias.sh &"
alias opjava="nautilus $JAVA_DIR";
CRBR="";

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

if [ ! -n "$PASSSQL" ]; then
  PASSSQL="root";
fi

function getdb() {
  dbuser="root";
  dbpass="$PASSSQL";
  dbname="$1";
  action="$2";
  if [ -n "$3" ]; then
    dbuser="$3";
  fi
  if [ -n "$4" ]; then
    dbpass="$4";
  fi
  
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
  user="root";
  pass="$PASSSQL";
  dbJcr="plf_mic_jcr";
  dbIdm="plf_mic_idm";
  action="no";
  Opwd="$PWD";
  cd $EXO_TOMCAT_BUILD;
  version=$(currentBranch);
  
  #--user=root --pass=root --db-jcr=plf_mic_jcr --db-idm=plf_mic_idm --help -h --rm -r
  
  input=($*);
  local i=0;
  for arg  in "$@" 
    do
     argM="${arg/--/}";
     (( ++i));
     next="${input[$i]}";
     if [ $(containText "user=" "$arg") == "OK" ]; then 
       user="${argM/user=/}";
     elif [ "$arg" == "-u" ]; then
       user="$next";
     elif [ $(containText "pass=" "$arg") == "OK" ]; then
       pass="${argM/pass=/}";
     elif [ "$arg" == "-p" ]; then
       pass="$next";
     elif [ $(containText "db-jcr=" "$arg") == "OK" ]; then
       dbJcr="${argM/db-jcr=/}";
     elif [ "$arg" == "-j" ]; then
       dbJcr="$next";
     elif [ $(containText "db-idm=" "$arg") == "OK" ]; then
       dbIdm="${argM/db-idm=/}";
     elif [ "$arg" == "-i" ]; then
       dbIdm="$next";
    elif [ $(containText "version=" "$arg") == "OK" ]; then
       version="${argM/version=/}";
     elif [ "$arg" == "-v" ]; then
       version="$next";
     elif [ "$arg" == "--rm" ] || [ "$arg" == "-r" ] || [ "$arg" == "rm" ]; then
       action="rm";
     elif [ "$arg" == "--help" ] || [ "$arg" == "-h" ]; then
       INFO "The function runbysql help configuration and run PLF-tomcat width db is mysql";
       echo "usage: runbysql [--user] [--pass] [--db-jcr] [--db-idm] [--remove] [-r] [--help] [-h] ";
       echo "";
       echo "Recursive:";
       echo "   -u   --user        The username to login your MySql server."
       echo "   -p   --pass        The password to login your MySql server."
       echo "   -j   --db-jcr      The database name to storage jcr."
       echo "   -i   --db-idm      The database name to storage system users."
       echo "   -r   --rm          Remove the old database on MySql and folder gatein/data on tomcat."
       echo "   -h   --help        Show help in console"
       echo "";
       echo "Mail bug reports and suggestions to <duytucntt@gmail.com>";
       echo "";
       action="cancel";
     fi 
  done
  #//
  if [ ! "$action" == "cancel" ]; then
    # //
    if [ -n "$version" ]; then
      eval "setTomcatDir $version";
    fi
    getTomcatDir;
    B=$(date +%H_%M_%d_%S);
    mv $EXO_TOMCAT/conf/server.xml $EXO_TOMCAT/conf/server_$B.xml;
    cp $EXO_TOMCAT/conf/server-mysql.xml $EXO_TOMCAT/conf/server.xml;
    cd $EXO_TOMCAT/conf/;
    if [ -e "$TOOL_HOME/libs/server.xml" ]; then
      INFO "cp $TOOL_HOME/libs/server.xml $EXO_TOMCAT/conf/";
      cp $TOOL_HOME/libs/server.xml $EXO_TOMCAT/conf/;
      eval "findsed 'plf_mic_jcr' '$dbJcr' 'server.xml'";
      eval "findsed 'plf_mic_idm' '$dbIdm' 'server.xml'";
      
      eval "findsed 'username=\"root\"' 'username=\"$user\"' 'server.xml'"
      eval "findsed 'password=\"root\"' 'password=\"$pass\"' 'server.xml'"
    else 
      eval "findsed 'plf' '$dbJcr' 'server.xml'";
      eval "findsed 'plf' '$dbIdm' 'server.xml'";
    fi
    if [ "$action" == "rm" ]; then
      cd ../
      rm -rf gatein/data/*
    fi
    cd $Opwd;
    eval "getdb $dbJcr $action $user $pass && getdb $dbIdm $action $user $pass && runtomcat" ;
  fi
  cd $Opwd;
}

function gedit() {
	eval "geany $* &";
}

alias mdfdl="gedit $TOOL_HOME/download.sh &"

function mdf_() { 
  eval "gedit $1 &"; 
}

alias mdf="mdf_";

alias gitlog='git log > /tmp/temp.log && sleep 1 && gedit /tmp/temp.log &';

alias gitconf="gedit .git/config";
alias cdmygit="cd mygit/";

patchDiff="/tmp/my";
function gitdiff() {
  other="";
  JIRA_NUMBER="";
  for arg  in "$@" 
    do
    if [ $(containText "-" "$arg") == "OK" ] && [ $(containText "/" "$arg") == "NOK" ]; then
      JIRA_NUMBER=$arg;
    else 
      other="$other $arg";
    fi
  done
  
  if [ ! -n "$JIRA_NUMBER" ]; then
    br=`currentBranch`;
    JIRA_NUMBER=${br/*\//};
  fi
  file_name="$patchDiff/$(date -u +%Y%m%d)-$JIRA_NUMBER.patch";
  INFO "git diff $other > $file_name && sleep 1s && gedit $file_name";
  git diff $other > $file_name && sleep 1s && gedit $file_name;
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
  echo "$TOOL_HOME";
  eval "rm -rf $HOME/.local/share/Trash/files/* $HOME/.local/share/Trash/info/* $HOME/.goutputstream* &";
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
  if [ -e "$TOOL_HOME/libs/injection-forum-4.1.0-SNAPSHOT.jar" ]; then
    INFO "cp $TOOL_HOME/libs/injection-forum-4.1.0-SNAPSHOT.jar $EXO_TOMCAT/lib/";
    cp "$TOOL_HOME/libs/injection-forum-4.1.0-SNAPSHOT.jar" "$EXO_TOMCAT/lib/"
  fi
  if [ -e "$TOOL_HOME/libs/social-extras-injection-4.1.0-SNAPSHOT.jar" ]; then
    INFO "cp $TOOL_HOME/libs/social-extras-injection-4.1.0-SNAPSHOT.jar $EXO_TOMCAT/lib/";
    cp "$TOOL_HOME/libs/social-extras-injection-4.1.0-SNAPSHOT.jar" "$EXO_TOMCAT/lib/"
  fi
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
      if [ -e "$tcDir/webapps/$folder/skin" ]; then
        INFO "Remove old folder $folder/skin"
        rm -rf $tcDir/webapps/$folder/skin/*
      fi
      if [ -e "${cssdirfolder}${folder}/skin" ]; then
        INFO "Copy files ${cssdirfolder}${folder}/skin into $tcDir/webapps/$folder/"
        eval "cp -rf ${cssdirfolder}${folder}/skin $tcDir/webapps/$folder/"
      fi
      if [ -e "${dirfolder}/templates" ]; then
        INFO "Copy files ${dirfolder}/templates into $tcDir/webapps/$folder/"
        eval "cp -rf ${dirfolder}/templates $tcDir/webapps/$folder/"
      fi
      if [ -e "${dirfolder}/groovy" ]; then
        INFO "Copy files ${dirfolder}/groovy into $tcDir/webapps/$folder/"
        eval "cp -rf ${dirfolder}/groovy $tcDir/webapps/$folder/"      
      fi
      if [ -e "${dirfolder}/javascript" ]; then      
        INFO "Copy files ${dirfolder}/javascript into $tcDir/webapps/$folder/"
        eval "cp -rf ${dirfolder}/javascript $tcDir/webapps/$folder/"
      fi
    fi
   done
}

function sendinject() {
	getTomcatDir;
	if [ $(expr match $EXO_TOMCAT "$PWD") -gt 0 ]; then
		INFO "Run tomcatinject...";
		eval "tomcatinject";
        if [ -e "$TOOL_HOME/exo-sample.properties" ]; then
            INFO "cp $TOOL_HOME/exo-sample.properties $EXO_TOMCAT/gatein/conf/exo.properties";
            if [ -e "$EXO_TOMCAT/gatein/conf/exo.properties" ]; then
                local B=$(date +%H_%M_%d_%S);
                mv $EXO_TOMCAT/gatein/conf/exo.properties $EXO_TOMCAT/gatein/conf/exo${B}.properties
            fi
            cp "$TOOL_HOME/exo-sample.properties" "$EXO_TOMCAT/gatein/conf/"
            mv $EXO_TOMCAT/gatein/conf/exo-sample.properties $EXO_TOMCAT/gatein/conf/exo.properties
        fi

		if [ -e "$TOOL_HOME/libs/crash.war" ]; then
			INFO "cp $TOOL_HOME/libs/crash.war $EXO_TOMCAT/webapps/";
			cp "$TOOL_HOME/libs/crash.war" "$EXO_TOMCAT/webapps/"
		fi

		if [ -e "$TOOL_HOME/libs/mysql-connector-java-5.1.13.jar" ]; then
			INFO "cp $TOOL_HOME/libs/mysql-connector-java-5.1.13.jar $EXO_TOMCAT/lib/";
			cp "$TOOL_HOME/libs/mysql-connector-java-5.1.13.jar" "$EXO_TOMCAT/lib/"
		fi

        if [ -e "$TOOL_HOME/libs/logback.xml" ]; then
			INFO "cp $TOOL_HOME/libs/logback.xml $EXO_TOMCAT/conf/";
			cp "$TOOL_HOME/libs/logback.xml" "$EXO_TOMCAT/conf/"
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
  pPrivate="-Pexo-private";
	command_="mvn clean install";
	if [ $(containText "tomcat" "$PWD") == "OK" ]; then
    CRBR_=$(currentBranch);
    CRBR_=${CRBR_/*\//};
    finder=$(find -maxdepth 3 -mindepth 3 -type d -name "*$CRBR_*");
    tomcat="setTomcatDir $CRBR_";
    if [ -n "$finder" ]; then
      echo "$finder";
      CRBR_=${finder/.\//};
      tomcat="setTomcatDir $EXO_TOMCAT_BUILD/$CRBR_";
    fi
    eval "$tomcat";
    command_="mvn install";
		isTomcat="-Dskip-archive -T2C";
		callback=" && $tomcat && sendinject";
		test="";
    if [ "$SET_DIR" == "OK" ]; then
      irm "$EXO_TOMCAT_DIR/lib/*";
      irm "$EXO_TOMCAT_DIR/webapps/*";
      irm "$EXO_TOMCAT_DIR/logs/*";
      irm "$EXO_TOMCAT_DIR/work/*";
      irm "$EXO_TOMCAT_DIR/temp/*";
      local B=$(date +%H_%M_%d_%S);
      mv $EXO_TOMCAT_DIR/conf/server.xml $EXO_TOMCAT_DIR/conf/server_$B.xml;
    fi
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
     elif [ $(containText "-o" "$arg") == "OK" ]; then 
				pPrivate="$arg";
		 else 
				other="$other $arg";
		 fi

   done


	INFO "$command_ $isTomcat $test$debug $pPrivate $T2C $other $callback";
  eval "$command_ $isTomcat $test$debug $pPrivate $T2C $other $callback";
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

PROJECTS="commons/ social/ wiki/ calendar/ forum/ platform/ integration/"

function ball() {
	cm="feature/stabilization";

	if [ -n "$1" ]; then
		cm="$1";
	fi
	INFO "cmprojectall '$PROJECTS platform-private-distributions/plf-enterprise-tomcat-standalone/' 'git co $cm && git pull --all && mvninstall'";
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


_runbysql() {
	local cur="${COMP_WORDS[COMP_CWORD]}";
  local opts="--user=root --pass=root --db-jcr=plf_mic_jcr --db-idm=plf_mic_idm --help -h --rm -r ${COMPREPLY[@]}";
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_runbysql" -o "default" "runbysql"


function A() {
  mkdir "$1" && cd "$1" && echo '' > "$1.sh" && gedit "$1.sh";
}

function killapp() {
  #eval "killall -15 $1";
  kill -9 `ps aux | grep "$1" | grep 'Sl' | awk '{print $2}'`;
}

function gitfilediff() {
  local version=$*;
  if [ ! -n "$version" ]; then
    version="HEAD~1";
  fi
  INFO "git diff $version | grep 'diff --git' | awk '{print \$3}'"
  eval "git diff $version | grep 'diff --git' | awk '{print \$3}'"
}

complete -F "_gitdiff" -o "default" "gitfilediff"

alias resource="source $HOME/.bashrc"

ALL_PROJECT="gatein/ platform-ui/ commons/ social/ ecms/ wiki/ forum/ calendar/ platform/ integration/ platform-public-distributions/ platform-private-distributions/";

function gitloggrep() {
  local vs="-200";
  if [ -n "$2" ]; then
    vs="$2";
  fi

  if [ -n "$1" ]; then
    eval "git lg $vs | grep '$1'";
  else
    INFO "Syntax: gitloggrep 'key-word' 'number-version'";
  fi
}

function tomcatbuildall() {
  eval "cmprojectall '$*' 'tomcatbuild -o'";
}

function teamblip() {
	INFO "mvninstall -o  && killTomcat && sleep 1s";
	eval "mvninstall -o  && killTomcat && sleep 1s";
	INFO "setTomcatDir 'stabilization'";
	eval "setTomcatDir 'stabilization'";
	INFO "cp target/team-b-addon-lib-1.0.x-SNAPSHOT.jar $EXO_TOMCAT/lib/";
	eval "cp target/team-b-addon-lib-1.0.x-SNAPSHOT.jar $EXO_TOMCAT/lib/";
}

function killas1() {
  eval "kill -9 `ps aux | grep as1 | grep EXO_DEV | awk '{print $2}'`";
}

function killadmin() {
  eval "kill -9 `ps aux | grep admin-tomcat | grep tenant.masterhost | awk '{print $2}'`";
}

function jmclass() {
  PID="`ps aux | grep as1 | grep EXO_DEV | awk '{print $2}'`";
  eval "jmap -histo:live $PID | grep '$*'";
}

function plflogin() {
  URL="$3";
  PRFIX="$2";
  NB="$1";
  for((i = 0; i< $NB; ++i)); 
     do
     eval "curl -u $PRFIX${i}:exo -s -v '$URL'";
  done
}
