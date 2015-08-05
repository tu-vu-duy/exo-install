#!/bin/bash
MV3=""
cygwin=false
os400=false
darwin=false
linux=false
case "`uname`" in
CYGWIN*) cygwin=true;;
OS400*) os400=true;;
Darwin*) darwin=true;;
Linux*) linux=true;;
esac

function INFO() {
  echo "[INFO] [$1]";
}

SCRIPTPATH=$BASH_SOURCE
alias mdfcm="gedit $SCRIPTPATH &"


function isWindow() {
  if [ "$cygwin" == "true" ]; then
    function nautilus() { 
      local now=$1;
      now=${now//\/cygdrive\/d/D:}
      now=${now//\//\\}
      eval "explorer.exe \"$now\" &"; 
    } 
    function gedit() { 
      if [ -n "$1" ]; then 
        local now=$PWD;
        now=${now//\/cygdrive\/d/D:}
        now=${now//\//\\}
        eval "notepad.exe $now/$1"; 
      fi
    }
  elif [ "$linux" == "true" ]; then
    function gedit() { 
      eval "command gedit $* &";
    }    
  fi

  if [ "$M2_HOME" == "$BSH_EXO_BASE_DIRECTORY/maven3.0.3" ]; then 
     MV3="-T2C";
  else 
     MV3="";
  fi
  
}

isWindow;

function npatchhelp() {
     echo "Usage the npatch command:"
     echo "      npatch [DIR] [--issue] [--patchdir]"
     echo " Expand command: svn diff DIR > patchdir/yeah-month-day-issueNumber.patch"
     echo 
     echo "Options: "
     echo 
     echo "DIR          is optional. If is empty, DIR = current dir"
     echo "*--issue      is optional. It is issue for create patch, if not, it is ramdom"
     echo "*--patchdir    is optional. It is dir of folder storage patch, if not --> current dir"
     echo 
}

function gotohelp() {
  echo "+ Goto projects: (We can use command for quick goto project)"
  echo " * ks22x ks21x ks12x kst ks2.1.x ... same for cs projects"
  echo " We can add new alias for other project by step: "
  echo " 1. Using command: cmdalias (open file exoalias.sh)"
  echo " 2. Add new alias by: alias aliasname=\"cdSource {projectname}{version}\". Ex: alias plf3.0.x=\"cdSource platform30x\" "
}

function tomcatHelp() {
  echo "+ Run tomcat:  "
  echo "       runtomcat [--version or --wk] [--debug=true/false]"
  echo " * tcrun (or runtc): help you can quick run tomcat in project you doing (current dir)"
  echo " * runtomcat (options): help you run tomcat via options is name of project ex: runtomcat --ks21x, runtomcat --ks22x v.v..."
  echo " And help you run tomcat by debug or not. If debug=true/(not this option), tomcat will run with command: 'gatein-dev.sh run' and with debug=false, command: 'gatein.sh run'"
  echo " If you not use options, the command will run same tcrun (or runtc)."
  echo
  echo "      cdtomcat/optomcat [--version]"
  echo "* cdtomcat: goto folder tomcat"
  echo "* optomcat: open folder tomcat"
}

function qmhelp() {
  echo "+ Quickwar and Module"
  echo "       ctmodule/ctquickwar [--test=true/false]  (if no option, test=true)"
  echo "* ctmodule : apply for build service of produce (build create a *.jar file). It will build produce --> replate new jar in lib/ of tomcat"
  echo "* ctquickwar : apply for build webapp of produce (build create a *.war file). It will build --> replate new war and remove old folder + old war in tomcat/webapps"
}

function cthelp() {
  echo
  echo "Wellcome command working for eXo Collaboration."
  echo
  echo "Feature : "
  echo
  gotohelp
  echo
  tomcatHelp
  echo
  qmhelp
  echo 
  npatchhelp
  echo "==========Using command cthelp for display this help.==========="
}

EXO_KS=$EXO_PROJECTS_SRC/exodev/ks
EXO_SOCIAL=$EXO_PROJECTS_SRC/exodev/social

CRPRJ=""
EXO_TOMCAT_DIR=$EXO_TOMCAT;
EXO_TOMCAT_BUILD=`echo $EXO_TOMCAT_DIR | grep --color=never 'target' | sed -e 's/\/target.*//'`;
EXO_TOMCAT_CONF="$EXO_TOMCAT_BUILD/target/";
EXO_PROJECTS=(tools portal gatein social ks forum cs platform platform-ui platform-private-distributions webos ecms commons integration)


# aliass extendsion: we can define quick goto project via use function cdSource with param = {projectname}{version}

alias social="cd exodev social/"
alias firefoxs="firefox http://localhost:8080/ &"
alias eclipse="$JAVA_DIR/eclipse/eclipse &"

alias tomcatCleanRun="tomcatClean && runtomcat"
alias runtc="runtomcat"
alias tcrun="runtomcat"

alias svnst="svn st"
alias svnup="svn up"
alias svnrmall="exosvn rm"
alias svnaddall="exosvn add"
alias svnrvall="svn revert -R \"\""
alias svndiff="svn diff"

ALISAS_SOURCE="";
# has function or alias: use hasfc functionname. Ex: hasfs kst
function hasfc() {
  command -v $1 >/dev/null && echo "Found" || echo "NotFound"
}

 # check existing . Ex: hasparam EXO_KS
function hasparam() {
  abc="\$$1"
  eval "abc=$abc"
  if [ -n "$abc" ]; then
     echo "Found"
  else
     echo "NotFound"
  fi 
}

# A contain B, $2 contain $1
function containText() {
	int1="$1";# B
	int2="$2";# A
	X=${int2/$int1/};
	if [ "$X" == "$int2" ]; then
		echo "NOK";
	else
		echo "OK";
	fi
}

function currentBranch() {
  cr=$(git branch | grep --color=never '\*');
  crs=($cr);
  CRBR="";
  for arg  in ${crs[@]}
    do
      if [ ! -e  "$PWD/$arg" ]; then
        CRBR=$arg;
      fi 
  done
  echo $CRBR;
}

function irm() {
  local RM="$1";
  if [ -n  "$RM" ]; then
    local S="";
    if [ $(containText "*" "$RM") == "OK" ]; then
      RM=${RM/\*/};
      S="*";
    fi
    if [ -e  "$RM" ]; then
      INFO "Removing folder/file: ${RM}${S}";
      eval "rm -rf ${RM}${S}";
    fi
  fi
}

# convert version: 
# in 12x ou branches/1.2.x, in 21x ou branches/2.1.x, in trunk ou trunk, in 2.0 tags out tags/2.0, in 20 tags out tags/2.0, in 2.2-GA tags out tags/2.2-GA
function cvVersion() {
  vs=$1
  vs="${vs/--/}"
  vs="${vs//./}"
  isTag=$2
  tp="trunk"
  if [ -n "$vs" ]; then
    if [ $vs != "trunk" ]; then
     X=0
     VS=""
     le=${#vs} 
     sr=`expr index "$vs" '-'`
     if [ $le -gt 0 ]; then 
       while [ $X -le $le ]
       do
        if [ $sr == 0 ]  || [ $X -le $((sr-3)) ]; then
          VS="$VS${vs:$X:1}"
          if [ $X -le $((le-2)) ]; then
            VS="$VS."
          fi
          X=$((X+1))
        else 
          VS="$VS${vs:$X}"  
          X=$((le+1))
        fi
       done
     fi
     if [ -n "$isTag" ]; then 
        tp="tags"
     else
        tp="branches"
     fi
     vs="$tp/$VS"
    fi
  fi
  echo "$vs"
}

function crash() {
	eval "getTomcatDir";
  if [ -e "$EXO_TOMCAT/webapps/crash.war" ]; then 
     INFO "crash: Run crash $EXO_TOMCAT/webapps/crash.war"
    else
     getCrsh
  fi
  sleep 10s 
  eval "telnet localhost 5000"
}

function getCrsh() {
   crdir="$JAVA_DIR/exo-dependencies/repository/org/crsh/crsh.jcr.exo/1.1.0/"
   if [ -e "$crdir/crsh.jcr.exo-1.1.0.war" ]; then
    cp $crdir/crsh.jcr.exo-1.1.0.war $HOME/
    mv $HOME/crsh.jcr.exo-1.1.0.war $EXO_TOMCAT/webapps/crash.war
    chmod +x  $EXO_TOMCAT/webapps/crash.war
    INFO "getCrsh: Run crash...."
   else
    eval "mkdir -p -m 777 $crdir"
    cd $crdir
    wget "http://repository.exoplatform.org/service/local/repositories/crsh-releases/content/org/crsh/crsh.jcr.exo/1.0.0/crsh.jcr.exo-1.0.0.war"
    cdback
    sleep 5s 
    getCrsh
   fi
}

# get current project: in {projectname}{version} ex: ks22x, platform30x, platformtrunk... out export info about project
# if param is null, return info about project via current dir.
function getCrproject() {
   if [ -n "$1" ]; then 
     DIR=$1
   else 
     DIR=$PWD
   fi
   TDIR=""
   ODIR=$PWD
  if [ -e "$DIR/.git" ]; then
     export CRPRJ=$DIR
  else
     TDIR=${DIR/$EXO_PROJECTS_SRC/}
      cd $DIR && cd ../
      DIR=$PWD
      cd $ODIR
     if [ ${#TDIR} -gt   9 ]; then
        eval "getCrproject $DIR "
     else
        INFO "Can not get project dir. You must use command for goto project, Ex: forum/"
     fi
  fi
}

function cdSource() {
  inFo=$1;
  inFo="${inFo/\//}";
  isINFO=$2;
  prj="";
  vs="";
  sb="";
  for X in ${EXO_PROJECTS[@]}
    do
     sb="${inFo/$X/}";
     if [ ${#sb}  != ${#inFo} ]; then 
       prj="$X";
       vs="$sb";
     fi
  done
  if [ ! -n "$prj" ]; then
    prj="$1";
    vs="$1";
  fi

  OPWD=$PWD;
  cd $EXO_PROJECTS_SRC;
  local pr=${prj/*\//};
	X=$PWD/`find -maxdepth 2 -type d -name "$pr*" | sed -e 's/\.\///'`;
	
	if [ "$X" == "$PWD/" ];then
			cd $OPWD;
	else
			INFO "Goto project $X";
			cd $X;	
	fi
 
  if [ ! -n "$vs" ]; then
    vs="$1";
  fi
  vs=$(cvVersion $vs);
  if [ -n "$vs" ] && [ -e "$PWD/$vs" ]; then
    if [ ! -n "$isINFO" ]; then 
     INFO "Goto version $vs";
    fi
    cd "$PWD/$vs";
  fi
}

function CD() {
  for arg  in "$@"
    do
     if [[ -e "$PWD/$arg" || -e "$arg" ]]; then
        eval "command cd ${arg// /\ }";
     else
       arg="${arg/--/}" 
       arg="${arg//./}"
       if [ $(hasfc $arg) == "Found" ]; then
         eval "$arg"
       else 
        eval "cdSource $arg"
       fi
     fi
  done
  
  if [ $(hasfc plfprompt) == "Found" ]; then
    if [ $(containText "tomcat-standalone" "$PWD") == "OK" ]; then
      eval "plfprompt";
    else
      eval "newprompt";
    fi
  fi
}

function  killTomcat() {
  currentTomcat;
  tomcatServerId="";
  if [ "$cygwin" == "true" ]; then
    tomcatServerId=`ps af | grep java | awk '{print $1}'`
  else
    tomcatServerId=`ps afx | grep --color=never '.*tomcat.*' | grep --color=never 'Djava' | awk '{print $1}'`
  fi

  if [ -n "$tomcatServerId" ]; then  
    kill -9 $tomcatServerId   
    INFO "Kill tomcat server id  $tomcatServerId";
    tomcatServerId="";
  else
  	INFO "Currently, The tomcat have not running.";
  fi 
}

function currentTomcat() {
  local TCDIR=`ps aux | grep 'Dgatein.conf.dir' | sed -e 's/.*Dgatein.conf.dir=//g' | awk '{print $1}'` 
  TC_DIR=`echo $TCDIR | awk '{print $1}'`;
  if [ -e "$TC_DIR" ]; then
     EXO_TOMCAT="${TC_DIR/\/gatein\/conf/}";
     echo "EXO_TOMCAT_DIR=$EXO_TOMCAT;  EXO_TOMCAT=$EXO_TOMCAT; export EXO_TOMCAT EXO_TOMCAT_DIR;" > "/tmp/my/tomcatdir.sh";
  elif [ ! -n "$EXO_TOMCAT" ]; then
    setTomcatDir;
  fi
}

alias cd="CD";
function runtomcat() {
	 isGetDir="";
   debug="";
   project="";
   profile_="default";
  for arg  in "$@" 
    do
     arg="${arg//-/}" 
     if [ "$arg" == "debug=false" ]; then
        debug="$arg"
     elif [ "$arg" == "debug=true" ]; then
        debug="$arg"
     elif [ $(expr match $arg "profile=") -gt 0 ]; then
        profile_="${arg/profile=/}";
     else 
        project=$arg;
     fi 
  done

  if [ -n "$project" ]; then
    eval "setTomcatDir $project";
  elif [ ! -e "$EXO_TOMCAT" ]; then
    eval "setTomcatDir && getTomcatDir";
  fi

  OPWD="$PWD"
  oldprj="$CRPRJ"
  if [ "$project" == "" ]; then
    eval "runByOtherDir $PWD $debug"
    return
  elif [  "$project" == "wk" ]; then
     eval "tcstart $EXO_WORKING_DIR $debug"
     return
  else 
     eval "runByParam $project $debug"
  fi
}

function runByOtherDir() {
  DIR=$1;
  debug=$2
  oldprj="$CRPRJ"
  eval "getCrproject $DIR"
  DIR="$CRPRJ"
  CRPRJ=$oldprj
  pkg="$PWD"
  if [ -e "$DIR/packaging/pkg/target" ];then
    pkg="$DIR/packaging/pkg/target"
  elif [ -e "$DIR/packaging/tomcat/target" ];then
    pkg="$DIR/packaging/tomcat/target"
  fi
  eval "tcstart $pkg $debug"
}

function runByParam() {
  project=$1;
  debug=$2
  project="${project//-/}" 
  project="${project//./}"
   if [ $(hasfc $project) == "Found" ]; then
      eval "$project"
   else 
     eval "cdSource $project false"
   fi
   eval "runByOtherDir $PWD $debug"
}

function getTomcatDir() {
  if [ -e "/tmp/my/tomcatdir.sh" ]; then 
    eval "command source /tmp/my/tomcatdir.sh";
  else
    currentTomcat;
  fi

	if [ ! -e "$EXO_TOMCAT" ] || [ $(containText "target" "$EXO_TOMCAT") == "NOK" ]; then
		local OLPWD=$PWD;
		local X="$EXO_TOMCAT_CONF";
		cd "$X";
		X=`find -maxdepth 5 -type f -name 'catalina.sh' | sed -e 's/bin.*//'`;
    X=`echo $X | awk '{print $1}'`;
		X=${X/\.\//};
		cd "$X";
		EXO_TOMCAT=$PWD;
		EXO_TOMCAT_DIR=$PWD;
		export EXO_TOMCAT EXO_TOMCAT_DIR;
		cd $OLPWD;
	fi
}

function setTomcatDir() {
  SET_DIR="";
  if [ -e "$1" ]; then
    EXO_TOMCAT="$1";
    EXO_TOMCAT_DIR="$1";
    SET_DIR="OK";
    echo "EXO_TOMCAT_DIR=$1;  EXO_TOMCAT=$1; export EXO_TOMCAT EXO_TOMCAT_DIR;" > "/tmp/my/tomcatdir.sh";
		export EXO_TOMCAT EXO_TOMCAT_DIR;
  elif [ $(containText "home/" "$1") == "NOK" ]; then
    rm -rf /tmp/my/tomcatdir.sh;
    if [ $(containText "4.0.x" "$1") == "OK" ]; then
       eval "setTomcatDir $EXO_TOMCAT_BUILD/target/platform-4.0.x-SNAPSHOT/platform-4.0.x-SNAPSHOT";
    elif [ $(containText "4.1.x" "$1") == "OK" ]; then
       eval "setTomcatDir $EXO_TOMCAT_BUILD/target/platform-4.1.x-SNAPSHOT/platform-4.1.x-SNAPSHOT";
    elif [ $(containText "4.1.0" "$1") == "OK" ] || [ $(containText "master" "$1") == "OK" ]; then
       eval "setTomcatDir $EXO_TOMCAT_BUILD/target/platform-4.2.x-SNAPSHOT/platform-4.2.x-SNAPSHOT";
    else
       CR=$PWD;
       local br="";
       if [ -e "$PWD/.git" ]; then
         br=`currentBranch`;
       fi
       if [ ! -n "$br" ]; then
         cd $EXO_TOMCAT_BUILD;
         br=`currentBranch`;
       fi
       if [ "$br" == "master" ]; then
         eval "setTomcatDir $br";
       elif [ -n "$br" ]; then
         cd $EXO_TOMCAT_BUILD;
         br=${br/*\//};
         br=`find -maxdepth 3 -mindepth 3 -type d -name "*$br*"`;
         br=${br/.\//};
         if [ -e "$EXO_TOMCAT_BUILD/$br" ]; then
           eval "setTomcatDir $EXO_TOMCAT_BUILD/$br";
         fi
       fi
       cd $CR;
    fi
  fi
}

function cdtomcat() {
	getTomcatDir;
  cd $EXO_TOMCAT_DIR
}

function optomcat() {
	getTomcatDir;
  INFO "Open folder: $EXO_TOMCAT_DIR"
  nautilus $EXO_TOMCAT_DIR
}

function tomcatClean() {
  Opwd=$PWD
  getTomcatDir;
  cd $EXO_TOMCAT_DIR
  rm -rf temp/* work/* logs/* gatein/data gatein/logs
  cd $Opwd
}

function tcstart() {
  SRC=$1
  debug_=$2
  isdb="has debug=true"
  if [ -n "$debug_" ]; then
  	if [ "$debug_" == "debug=true" ]; then
      isdb="has debug=true"
      debug="--dev --debug"
      EXO_DEV=true;
      EXO_DEBUG=true;
      EXO_TOMCAT_UNPACK_WARS=true;
      export EXO_DEBUG EXO_DEV EXO_TOMCAT_UNPACK_WARS;
    else 
      debug=""
      isdb="has debug=false"
      EXO_DEV=false;
      EXO_DEBUG=false;
      EXO_TOMCAT_UNPACK_WARS=false;
      export EXO_DEBUG EXO_DEV EXO_TOMCAT_UNPACK_WARS;
    fi
  fi
  
  if [ -e "$OPWD" ]; then
    cd "$OPWD";
  fi

  if [ -e "$EXO_TOMCAT_DIR/run_eXo.sh" ]; then
  	sed -i -e 's/\".\/bin\/catalina.sh/\/\"bin\/catalina.sh/g' $EXO_TOMCAT_DIR/run_eXo.sh;
  	INFO "Run tomcat $isdb in $EXO_TOMCAT_DIR";
    echo "EXO_TOMCAT_DIR=$EXO_TOMCAT_DIR;  EXO_TOMCAT=$EXO_TOMCAT; export EXO_TOMCAT EXO_TOMCAT_DIR;" > "/tmp/my/tomcatdir.sh";
    eval "sleep 1s && $EXO_TOMCAT_DIR/run_eXo.sh $debug" 
  elif [ -e "$EXO_TOMCAT_DIR/start_eXo.sh" ]; then
    local X=" $profile_";
    if [ -n "$2" ]; then
      X=" $X";
    fi
    profile_="";
    sed -i -e 's/\".\/bin\/catalina.sh/\/\"bin\/catalina.sh/g' $EXO_TOMCAT_DIR/start_eXo.sh;
    INFO "Run tomcat $isdb in $EXO_TOMCAT_DIR";
    echo "EXO_TOMCAT_DIR=$EXO_TOMCAT_DIR;  EXO_TOMCAT=$EXO_TOMCAT; export EXO_TOMCAT EXO_TOMCAT_DIR;" > "/tmp/my/tomcatdir.sh";
    eval "sleep 1s && $EXO_TOMCAT_DIR/start_eXo.sh $debug" 
  elif [ ! -n "$isGetDir" ]; then
  		isGetDir="false";
  		eval "getTomcatDir && sleep 1s && tcstart";
  else
      INFO  "Can not get tomcat dir. "
  fi
}

function npatch() {
  patchdir=$PWD;
  issue="$(date -u +%h%M)";
  DIR="";
  for arg  in "$@" 
    do
     arg="${arg/--/}" 
     if [ $(expr match $arg "patchdir=") -gt 0 ]; then 
       patchdir="${arg/patchdir=/}";
     elif [ $(expr match $arg "issue=") -gt 0 ]; then
       issue="${arg/issue=/}";
     elif [ $(expr match $arg "help") -gt 0 ]; then
       npatchhelp;
       return
     elif [ -e "$PWD/$arg" ]; then 
       DIR="$arg";
     fi 
    done
  INFO "Create new patch for issue: $issue (file name: $(date -u +%Y-%m-%d)-$issue.patch) And save into folder : $patchdir"
  svn diff $DIR > $patchdir/$(date -u +%Y-%m-%d)-$issue.patch
  return
}

function updatebuilds() {
  eval "updates $*";
  eval "builds $*";
}

function updates() {
 local udPWD=$PWD;
 src=""
 for arg  in "$@" 
  do
    src="${arg//-/}" 
    src="${src//./}"
    if [ $(hasfc $src) == "Found" ]; then
       eval "$src"
    else 
       eval "cdSource $src"
    fi
    INFO "Updating now $PWD" &&  svn up && cd $udPWD;
  done
 return
}

function builds() {
  local udPWD=$PWD;
  eval "getparam $*";
  for arg  in "${projects[@]}" 
  do
    eval "cdSource $arg"
    INFO "Building now $PWD" &&  mvn clean install $MV3 $bdebug $udrepo && $eclipse && cd $udPWD;
  done
 return
}


function getparam() {
  projects=();
  update="";
  isbuild="";
  tcdir="";
  tomcatdir="";
  istest="";
  istomcat=true;
  isHelp=false;
  udrepo="";
  eclipse="";
  debug="";
  bdebug="";
  tomcatstart="tomcatstart=false";
  Dtest="";
  other="";
  OLPWD="$PWD";
  idx=0;
  profile="default";
  if [ ! -n "$1" ]; then
    isHelp=true;
  fi
  for arg  in "$@" 
    do
     arg="${arg/--/}" 
     arg="${arg//./}"
     eval "cdSource $arg false";
     if [ "$PWD" != "$OLPWD" ]; then 
       projects[$idx]=$arg;
       cd $OLPWD;
     else

       if [ "$arg" == "test=false" ]; then
          istest="-Dmaven.test.skip=true";
       elif [ "$arg" == "up" ] || [ "$arg" == "update" ]; then 
          update="svn up";
       elif [ "$arg" == "build" ] || [ "$arg" == "install" ]; then 
          isbuild="mvn clean install";
       elif [ "$arg" == "debug" ]; then 
          bdebug="-Dmaven.surefire.debug=true";
       elif [ "$arg" == "tomcat=false" ] || [ "$arg" == "buildnottc" ]; then 
          istomcat="-P !pkg-tomcat";
       elif [ "$arg" == "eclipse" ]; then 
          eclipse="mvn eclipse:eclipse";
       elif [ $(expr match $arg "tomcatstart=") -gt 0 ]; then
          tomcatstart="$arg";
       elif [ $(expr match $arg "tomcatdir=") -gt 0 ]; then
        tomcatdir="${arg/tomcatdir/-Dgatein.working.dir}";
       elif [ $(expr match $arg "udrepo") -gt 0 ]; then
        udrepo="-U";
       elif [ $(expr match $arg "profile=") -gt 0 ]; then
        profile="${arg/profile=/}";
       elif [ $(expr match $arg "debug=") -gt 0 ]; then
        debug="$arg";
       elif [ $(expr match $arg "D") -gt 0 ]; then
        Dtest="$arg $Dtest";
       elif [ $(expr match $arg "help") -gt 0 ] ; then
        isHelp=true;
       else 
          other="$arg";
       fi

     fi
     ((idx++))
   done

}
#-Dtest=classname
#-Dmaven.surefire.debug=true
function ctbuild() {
  eval "getparam $*";
  if [ $isHelp == true ]; then
    qmhelp;
    return;
  fi
  INFO "Building project $PWD"
  INFO "Command: mvn clean install $MV3 $bdebug $Dtest $istest $udrepo "
  eval "mvn clean install $MV3 $bdebug $Dtest $istest $udrepo" && 
  eval "$eclipse";
}


function ctmodule () {
  eval "getparam $*";
  eval "mvn clean install $MV3 $istest $Dtest $udrepo" && 
  if [ -e "$PWD/target" ]; then
     OPWD=$PWD
     eval "getCrproject $PWD"
     INFO "Stop the tomcat in $EXO_TOMCAT_DIR";
     killTomcat;
     INFO "Copy file jar into $EXO_TOMCAT_DIR/lib"
     cp target/*.jar $EXO_TOMCAT_DIR/lib
     cd $EXO_TOMCAT_DIR/lib
     find -depth -name *sources.jar -exec rm -rf {} \; 
     cd $OPWD &&
     if [ "$tomcatstart" == "tomcatstart=true" ]; then
       sleep 1s;
       eval "runtomcat $debug $profile";
     fi
  fi
}

function ctquickwar () {
  eval "getparam $*";
  eval "mvn clean install $MV3 $istest $Dtest $udrepo" && 
   if [ -e "$PWD/target" ]; then
    nowDir=$PWD
    eval "getCrproject $PWD"
    temp=$(find -maxdepth 2 -name *.war)
    temp="${temp/.\/target\//}"
    temp="${temp/.war/}"
    if [ -e "$PWD/target/$temp.war" ]; then
      INFO "Stop the tomcat in $EXO_TOMCAT_DIR";
      killTomcat;
      INFO "Copy file $temp.war into $EXO_TOMCAT_DIR/webapps"
      cp target/$temp.war $EXO_TOMCAT_DIR/webapps
      chmod +x  $EXO_TOMCAT_DIR/webapps/* -R
      INFO "Remove old folder $temp"
      rm -rf $EXO_TOMCAT_DIR/webapps/$temp/;
      cd $nowDir &&
      if [ "$tomcatstart" == "tomcatstart=true" ]; then
        sleep 1s;
        eval "runtomcat $debug $profile";
      fi
    fi
   fi
}

function getWarName() {
  if [ $(containText "social/webapp/portlet" "$PWD") == "OK" ]; then
    echo "social-portlet";
  elif [ $(containText "social/webapp/resources" "$PWD") == "OK" ]; then
    echo "social-resources";
  elif [ $(containText "forum/forum/webapp" "$PWD") == "OK" ]; then
    echo "forum";
  elif [ $(containText "forum/forumResources" "$PWD") == "OK" ]; then
    echo "forumResources";
  elif [ $(containText "forum/poll/webapp" "$PWD") == "OK" ]; then
    echo "poll";
  elif [ $(containText "commons/commons-comet-webapp" "$PWD") == "OK" ]; then
    echo "cometd";
  elif [ $(containText "commons/commons-extension-webapp" "$PWD") == "OK" ]; then
    echo "commons-extension";
  elif [ $(containText "commons/commons-webui-resources" "$PWD") == "OK" ]; then
    echo "CommonsResources";
  elif [ $(containText "platform/extension/webapp" "$PWD") == "OK" ]; then
    echo "platform-extension";
  elif [ $(containText "calendar-extension/calendar-extension-webapp" "$PWD") == "OK" ]; then
    echo "calendar-extension";
  else
    echo "";
  fi
}

function sendtotomcat() {
   tcDir="$1";
   juzu="$2";
   INFO "Find all file *.war";
   eval "find -type d -name 'bin' | xargs rm -rf";
   wars=$(find -name *.war)
   temp="";
   for X in ${wars[@]}
    do
    if [ $(containText "target" "$X") == "OK" ]; then
			temp="${X/.*target\//}";
			y="$(expr match "$temp" '.*\(/\)')";
			if [ "$y" == "" ]; then
        folder=`getWarName`;
        if [ ! -n "$folder"  ]; then
          folder="${temp/.war/}";
        fi
        INFO "Copy file $temp into $tcDir/webapps/${folder}.war"
        cp $X $tcDir/webapps/${folder}.war
        INFO "Remove old folder $folder"
        rm -rf $tcDir/webapps/$folder/
			fi
    fi
   done
   
   if [ -e "$PWD/target/classes/juzu" ]; then
		 juzu="juzu";
   fi

   if [ $(containText "juzu" "$PWD") == "NOK" ] && [ "$juzu" != "juzu" ]; then 
		 INFO "Find all file *.jar";
		 jars=$(find -name *.jar)
		 for X in ${jars[@]}
			do
			 temp="${X/.*target\//}";
			 t="$(expr match "$temp" '.*\(sources\)')";
			 y="$(expr match "$temp" '.*\(lib/\)')";
			 if [ "$t" == "" ] && [ "$y" == "" ]; then
				 INFO "Copy file $temp into $tcDir/lib"
				 cp $X $tcDir/lib
			 fi
		 done
	 fi
}

function toplftrunk() {
  eval "totomcat platformtrunk"
}

function totomcat() {
  OD="$PWD";
  dirS=$1
  if [ -n "$dirS" ]; then 
     dirS="${dirS/--/}" ;
     eval "cdSource $dirS false";
  fi
  killTomcat;
  cd $OD;
  eval "sendtotomcat $EXO_TOMCAT";
}

function buildtotomcat() {
  eval "getparam $*";
  eval "mvn clean install $MV3 $istest $Dtest $udrepo" && 
  eval "getCrproject $PWD" && 
  eval "totomcat" &&
  if [ "$tomcatstart" == "tomcatstart=true" ]; then
    sleep 1s;
    eval "runtomcat $debug $profile";
  fi
}

function getProject() {
    src=$EXO_PROJECTS_SRC/$1
    if [ -e "$src" ]; then 
       echo $arg;
    fi
    echo "";
}

function getVersion() {
    arg=$(cvVersion $1)
    if [ -e "$EXO_PROJECTS_SRC/$2/$arg" ]; then 
       echo $1;
    fi
    echo  "";
}

function ctHelp () {
  echo "Usage the ct command: "
  echo 
  echo "  ct [--product-name] [--version]  [--update]  [--build] [--install] [--buildnottc] [--test] [--test=true/false] [--tomcatdir=target]"
  echo 
  echo "Options: "
  echo 
  echo "  * --product-name    is optional. The possible names are --ks or --cs"
  echo "  * --version        is optional but when you add it, you must add the --product-name."
  echo "                    The possible names are --1.2.x/1.3.x/2.1.x/2.2.x/trunk or --12x/13x/21x/22x/trunk"
  echo "  * --update  / --up   is optional. If you add this option, exobuild will make a svn update before it builds"
  echo "  * --build          is optional. If you add this option, the exobuild command mvn clean install"
  echo "  * --buildnottc      is optional. If you add this option, the exobuild produce but not create the tomcat "
  echo "  * --test           is optional. If you add this option, the exobuild will only run exo webunit test framework"
  echo "  * --test=true/false  is optional. If you add this option, the exobuild produce but you can choise is run test or not"
  echo "  * --tomcatdir       is optional. If you add this option, you can set tomcat dir, if not add tomcat dir default is /pkg/target dir. Only use for 2.0 and more"
  echo "  * --U  is optional. If you add this option when you build project, it will update new repositories"
  echo "  * --module/quickwar is optional. same when use ctquickwar/ctmodule but not param "
  echo "  * --eclipse is optional. If you add this option, mvn will build for command: mvn eclipse:eclipse"
  echo 
  echo " Extension: "
  echo "    ct [ ... all options support by ct command]  [ other command]"
  echo " If you want add new command when finish run all options of ct command, you can add it is last option. If it has space ' ', you must add it in \"\""
  echo " Ex1: ct --ks --22x --buid --runtomcat"
  echo " Ex2: ct --cs --22x --update --buid \"runtomcat --ks22x\""
  echo 
  echo "Example: "
  echo "  ct  --ks --2.2.x --update --buildnottc --test=false"
  echo "  ct  --update --install --test=true --tomcatdir=/home/exo/java/exo-working (run in current dir)"
  echo "  ct  --update (run mvn clean install in current dir)"
  echo "  ct  --buildnottc (run mvn clean install -P !pkg-tomcat in current dir)"
  echo "  ct  --ks --12x (go to ks/branches/1.2.x)"
  echo "  ct  --ks --12x --update --build (go to ks/branches/1.2.x and update and build and create exo-tomcat in pkg/target)"
  echo 
  echo " Luck for you ^^ Contac for me via duytucntt@gmail.com "
  echo 
}

function ct() {
  eval "getparam $*";
  tomcatstart="";
  project="";
  version="";
  lastCm="";
  for arg  in "$@" 
    do
      arg="${arg/--/}"
      arg="${arg//./}"
     if [ "$arg" == "trunk" ]; then 
       version="trunk"
     elif [ $(expr match $arg "1") -gt 0 ] ||
         [ $(expr match $arg "2") -gt 0 ] ||
         [ $(expr match $arg "3") -gt 0 ] ||
         [ $(expr match $arg "4") -gt 0 ] ||
         [ $(expr match $arg "5") -gt 0 ] ; then
       version="$arg";
     elif [ $(expr match $arg "tomcatstart=") -gt 0 ]; then
       tomcatstart="$arg";
     elif [[ "$arg" == "U" || "$arg" == "-U" ]]; then
       udrepo="-U";
     else
        pr=$(getProject $arg)
        if [ -n "$pr" ]; then 
          project="$pr";
        fi
        vs=$(getVersion $arg $project);
        if [ -n "$vs" ]; then 
           version="$vs"
        fi
        if [ ! -n "$pr" ] && [ ! -n "$vs" ]; then
          if [ $(hasfc $arg) == "Found" ]; then
             lastCm="$arg"
          fi
        fi
     fi 
  done

  if [ $isHelp == true ]; then 
    ctHelp
    return
  fi

  if [ -n "$project" ]; then
    eval "cdSource $project$version";
  else
    eval "cdSource $lastCm";
  fi

  if [ -n "$update" ]; then
    INFO "Updating: $PWD"
    eval "$update"
  fi

#$ -Ppkg-tomcat=tomcat
  if [ -n "$isbuild" ]; then
    if [ "$istomcat" == "true" ]; then
      if [ -n "$tomcatdir" ]; then 
        eval "mkdir -p -m 777 $tomcatdir"
      fi
      INFO "Run command: $isbuild $MV3 $istest $udrepo $bdebug $Dtest $tomcatdir";
      eval "$isbuild $MV3 $istest $udrepo $bdebug $Dtest $tomcatdir";
    else
     INFO "Run command: $isbuild $MV3 $istest $udrepo $bdebug $Dtest $istomcat";
     eval "$isbuild $MV3 $istest $udrepo $bdebug $Dtest $istomcat";
    fi
  fi

  if [ -n "$eclipse" ]; then
    INFO "$eclipse  $PWD"
    eval "mvn eclipse:clean && $eclipse"
  fi
  if [ -n "$lastCm" ]; then
    eval "$lastCm"
  fi
  if [ -n "$tomcatstart" ]; then
    eval "runtomcat $debug"
  fi
}

function exosvnco() {
  prj=$1
  prj="${prj//-/}"
  vs=$2
  isTag=$3

  if [ -n "$vs" ]; then
    tp=""
    if [ "$vs" != "trunk" ];then
       tp="/branches"
    fi
    vs=$(cvVersion $vs $isTag)
    if [ -n "$vs" ]; then
       eval "mkdir -p -m 777 $EXO_PROJECTS_SRC/$prj$tp"
       cd $EXO_PROJECTS_SRC/$prj
       INFO "Check out project $prj with version $vs"
       if [ -n "$USER" ] && [ -n "$PASS" ]; then 
         eval "svn co --username=$USER --password=$PASS http://svn.exoplatform.org/projects/$prj/$vs $vs"
       else
         eval "svn co http://svn.exoplatform.org/projects/$prj/$vs $vs"
       fi
       cdback
    fi
  fi
}

function mvst() {
  USER="$1"
  PASS="$2"
  if [ -n "$USER" ] && [ -n "$PASS" ]; then
    eval "cd $BSH_EXO_BASE_DIRECTORY/maven3.0.3/conf && mv settings.xml settings_b.xml && wget --http-user=$USER  --http-password=$PASS http://storage.exoplatform.vn/ct/tu_vu_duy/settings.xml && find -depth -name settings.xml | xargs sed -i -e 's/USERID/$USER/g' && find -depth -name settings.xml | xargs sed -i -e 's/PASS/$PASS/g' && find -depth -name settings.xml | xargs sed -i -e 's/JAVADIR/${BSH_EXO_BASE_DIRECTORY//\//\\/}/g'"
  fi
}

function mdfsetting() { 
  gedit "$M2_HOME/conf/settings.xml";
}

function unzipmv3() {
   if [ $(hasfc "unzip") == "Found" ]; then
      echo "UnZip to  $PWD/maven3.0.3..."
      eval "unzip apache-maven-3.0.3-bin.zip && mv apache-maven-3.0.3 maven3.0.3"
   else 
     eval "sudo apt-get install unzip && unzipmv3"
   fi
}

function umaven2() {
   M2_HOME=$BSH_EXO_BASE_DIRECTORY/maven2.2.1;
   PATH=${PATH//maven3.0.3/maven2.2.1};
   MV3="";
}

function umaven3(){
   M2_HOME=$BSH_EXO_BASE_DIRECTORY/maven3.0.3 ;
   PATH=${PATH//maven2.2.1/maven3.0.3};
   MV3="-T2C";
}

function installmv3() {
  USER="$1"
  USER="${USER/--username=/}"
  PASS="$2"
  PASS="${PASS/--pass=/}"

  if [ -n "$USER" ]; then 
     eval "cd $BSH_EXO_BASE_DIRECTORY"
     echo "download maven 3 in to  $PWD"
     eval "wget --http-user=$USER  --http-password=$PASS http://storage.exoplatform.vn/ct/tu_vu_duy/apache-maven-3.0.3-bin.zip && unzipmv3 && mvst $USER $PASS"
     echo  " Note: "
     echo "If you want to user maven3, plesase type command: umaven3. The default system user maven2.2.1. "
     echo "If you want to user maven2.2.1, plesase type command: umaven2."
     echo
  else 
     echo "----------------------------- HELP -------------------------------"
     echo "Please input the user info of eXo (info about svn accout). Syntax: installmv3 --username=USERID  --pass=PASS"     
     echo "If you have not it, you can user Syntax: installmv3 no"
     echo  
  fi
}


function exoinitallHelp() {
  echo "Syntax:"
  echo "   exoinitall --username=USERID  --pass=PASS --javahome=dir --projects=p1/vs,p2/vs...."
  echo 
  echo "Options: "
  echo "  *  --username and --pass: Provide by ExoPlatform company"
  echo " "
  echo "  If you have not it. You can ignored."
  echo
  echo " If you want to set the java home, you must set param: "
}

function exoinitall() {
  javahome=""
  for arg  in "$@" 
    do
      arg="${arg/-/}"
     if [ "$arg" == "start" ]; then
       echo
     fi 
  done

  eval "cd $javahome";
  eval "mkdir -p -m 777 java/eXoProjects"
  eval "mkdir -p -m 777 java/exo-dependencies/repository"
  eval "mkdir -p -m 777 java/exo-working"
  eval "cd java"
   if [ -n "$USER" ] && [ -n "$PASS" ]; then 
echo 
  fi
}

function helpall() {
  INFO "All function support:";
  INFO "npatch: Create file patch";
  INFO "gpatch: Read new file patch crated.";
  INFO "runtomcat: run the tomcat by produce.";
  INFO "builds: Build all product by option";
  INFO "updates: Update all product by option";
  INFO "updatebuilds: Update and build all produce by option";
  INFO "cdSource: Go to dir by option";
  INFO "ctbuild: Build project by option";
  INFO "ctmodule: Build service and copy jar to tomcat by option";
  INFO "ctquickwar: Build webapp and copy war to tomcat by option";
  INFO "buildtotomcat: Build webapp & service and copy war/jar to tomcat by option";
  INFO "totomcat: Copy war/jar to tomcat by option";
  INFO "toplftrunk: Copy war/jar to tomcat of platform trunk by option";
  INFO "umaven2: Use maven version 2.2.1";
  INFO "umaven3: Use maven version 3.0.3";
  INFO "ct: The function with general option";
  INFO "exosvnco: Check out product by option";
  eval "echo && cthelp && echo && ctHelp";
}

function mvn2() {
  cr=$MV3;
  eval "umaven2";
    eval "command mvn $*";
  if [ -n "$cr" ]; then
    eval "umaven3";
  fi
}

function mvn3() {
  cr=$MV3;
  eval "umaven3"
  eval "command mvn $MV3 $*";
  if [ ! -n "$cr" ]; then
    eval "umaven2";
  fi
}

function mvnoption() {
#Xms512m -Xmx1536m -XX:MaxPermSize
#-XX:MaxPermSize=256m -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
Xms="512m";
Xmx="1536m";
MaxPermSize="256m";
Xdebug="false";
Exten="";
 for arg  in "$@" 
  do
    if [ $(expr match $arg "Xms=") -gt 0 ]; then
          Xms="${arg/Xms=/}";
    elif [ $(expr match $arg "Xmx=") -gt 0 ]; then
          Xmx="${arg/Xmx=/}";
    elif [ $(expr match $arg "MaxPermSize=") -gt 0 ]; then
          MaxPermSize="${arg/MaxPermSize=/}";
    elif [ $(expr match $arg "Xms=") -gt 0 ]; then
          Xms="${arg/Xms=/}";
    elif [ $(expr match $arg "Xdebug=true") -gt 0 ]; then
          Xdebug="${arg/Xdebug=/}";
    else 
         Exten="$arg $Exten";
    fi
  done
  OPS="-Xshare:auto -Xms$Xms -Xmx$Xmx -XX:MaxPermSize=$MaxPermSize";
  if [ "$Xdebug" == "true" ]; then
    OPS="$OPS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005";
  fi
  MAVEN_OPTS="$OPS";
  export MAVEN_OPTS;
}
_mvnoption() {
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="Xms=512m Xmx=1536m MaxPermSize=256m Xdebug=true";
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_mvnoption" -o "default" "mvnoption"
######
# Extension 

function gpatch() {
  file="$(date -u +%Y-%m-%d).patch";
  svn diff > $file;
  sleep 1s;
  eval "gedit $file &";
  sleep 1s;
  rm $file;
}

# auto complete

_setTomcatDir ()  
{

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="stabilization notifications 4.0.x 4.1.x 4.1.0"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_setTomcatDir" -o "default" "setTomcatDir"

_runtomcat ()  
{           

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="$ALISAS_SOURCE 4.0.x 4.1.x 4.1.0 stabilization notifications debug=true profile="
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_runtomcat" -o "default" "runtomcat"

_ctbuild ()  
{           

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="debug=true test=false tomcatstart=true"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}


complete -F "_ctbuild" -o "default" "ctbuild"

complete -F "_ctbuild" -o "default" "ctmodule"
complete -F "_ctbuild" -o "default" "ctquickwar"
complete -F "_ctbuild" -o "default" "buildtotomcat"

_ctinstall ()  
{           

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="debug=true test=false udrepo debug"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_ctinstall" -o "default" "updatebuilds"
complete -F "_ctinstall" -o "default" "builds"
complete -F "_ctinstall" -o "default" "updates"

_ctsource ()  
{           

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="$ALISAS_SOURCE"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_ctsource" -o "default" "cdSource"
complete -F "_ctsource" -o "default" "updatebuilds"
complete -F "_ctsource" -o "default" "builds"
complete -F "_ctsource" -o "default" "updates"

_npatch ()  
{

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="issue= patchdir= help"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_npatch" -o "default" "npatch"

_ct ()  
{

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="${EXO_PROJECTS[@]} up update build install debug test= tomcat= U eclipse ctmodule ctquickwar 12x 11x 21x 22x trunk tomcatdir= onlytomcat buildnottc help tomcatstart=true debug=true"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_ct" -o "default" "ct"

_exosvnco ()  
{

  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="${EXO_PROJECTS[@]} 12x 11x 21x 22x trunk tag 121-GA 220-GA 211-GA"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_exosvnco" -o "default" "exosvnco"


_CD() {
  _cd;
  local cur="${COMP_WORDS[COMP_CWORD]}";
  local opts="$ALISAS_SOURCE ${EXO_PROJECTS[@]} ${COMPREPLY[@]}";
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

if [ "$linux" == "true" ]; then
  alias cd="CD";
#  complete -F "_CD" -o "default" "cd";
fi

