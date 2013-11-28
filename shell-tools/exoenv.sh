##################### Working Environment ########################################
#userever=$(whoami)
PORTABLE_DIR=/home/$(whoami)

##################### VARIABLE TO CUSTOMIZE ########################################
PORTABLE_DIR=`echo $PORTABLE_DIR | sed -e 's/\\\/\\//g'`
PORTABLE_DIR=`echo $PORTABLE_DIR | sed -e 's/\\/$//g'`
JAVA_DIR=$PORTABLE_DIR/java

OLD=$PWD
cd $JAVA_DIR
EXO_BASE_DIRECTORY=$PWD
JAVA_HOME="$EXO_BASE_DIRECTORY/jdk1.6"

BSH_EXO_BASE_DIRECTORY=$JAVA_DIR
BSH_JAVA_HOME=$JAVA_HOME
BSH_M2_REPOS="file:$BSH_EXO_BASE_DIRECTORY/exo-dependencies/repository"

##################################################################################
USER_HOME='/cygdrive/c/Documents\ and\ Settings/$USERNAME'

EXO_PROJECTS_SRC=$EXO_BASE_DIRECTORY/eXoProjects
EXO_WORKING_DIR=$EXO_BASE_DIRECTORY/exo-working

M2_HOME="$EXO_BASE_DIRECTORY/maven3.0.4"

if [ ! -e $M2_HOME ]; then 
  M2_HOME=$JAVA_DIR/`ls --color=never $JAVA_DIR | grep --color=never 'maven.*3.0.' | awk '{print $1}'`
  cd $M2_HOME;
  M2_HOME=$PWD;
  cd $JAVA_DIR;
fi

M2_REPO="$EXO_BASE_DIRECTORY/exo-dependencies/repository, http://repository.exoplatform.vn/nexus/content/groups/all, http://repo1.maven.org/maven2"
MAVEN_OPTS="-Xshare:auto -Xms512m -Xmx1536m -XX:MaxPermSize=128m" 
T2C="";
EXO_DEV=true;
EXO_DEBUG=true;
EXO_TOMCAT_UNPACK_WARS=true;
EXO_JCR_SESSION_TRACKING=false;

#echo "This is a test"
JAVA_OPTS="-Xshare:auto -Xms512m -Xmx1536m -XX:MaxPermSize=128m -Dexo.directory.base=$EXO_BASE_DIRECTORY" 
PATH=/usr/local/bin:$JAVA_HOME/bin:$PATH:$M2_HOME/bin

if [ "$OLD" == "$PORTABLE_DIR" ] ; then
	cd "$EXO_PROJECTS_SRC";
else 
	cd $OLD;
fi
JIRA_NUMBER="TEMP"

export JAVA_OPTS JAVA_HOME M2_HOME M2_REPO MAVEN_OPTS JIRA_NUMBER PATCH_FILES EXO_JCR_SESSION_TRACKING EXO_TOMCAT_UNPACK_WARS
export EXO_BASE_DIRECTORY EXO_PROJECTS_SRC  BSH_EXO_BASE_DIRECTORY  BSH_M2_REPOS BSH_JAVA_HOME EXO_DEV EXO_DEBUG

source "$TOOL_HOME/exoalias.sh";
source "$TOOL_HOME/exoct.sh";
source "$TOOL_HOME/myalias.sh";
source "$TOOL_HOME/injector_forum.sh";
source "$TOOL_HOME/social-tools.sh";

eval "X=(${PWD//\// })"
if [ -n "${X[9]}" ]; then 
  eval "plfprompt";
fi
