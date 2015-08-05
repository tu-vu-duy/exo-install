ME=$(whoami);
HOME="/home/$ME";
USER_HOME=$HOME;

PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
 
PRGDIR=`dirname "$PRG"`;

cd $PRGDIR;

function INFO() {
    echo "INFO $*";
}

function makeFolder() {
  cd $HOME;
  INFO "Create folders ..."
  eval "mkdir -p -m 777 $HOME/java/eXoProjects/exodev"; 
  eval "mkdir -p -m 777 $HOME/java/exo-dependencies/repository";
}
makeFolder;

# copy maven
function cpmaven() {
  INFO "Copy maven-3.2.5";
  eval "cp -rf apache-maven-3.2.5 $HOME/java/";
  sleep 1s;
}
cpmaven;

function cptools() {
  INFO "Copy Tools";
  eval "cp -rf shell-tools $HOME/java/exodev/";
  sleep 1s;
}
cptools;

function configEnv() {
  INFO "Configuration env";
  eval "cp $USER_HOME/java/exodev/shell-tools/replace.bashrc $HOME/.bashrc";
}
configEnv;

function configSettings() {
  ME=$(whoami);

  INFO "Configuration settings.xml of maven";
  INFO "If you configuration error, you can open the file $HOME/java/apache-maven-3.2.5/conf/settings.xml and manual configuration";

  cd "$HOME/java/apache-maven-3.2.5/conf"
  eval "find -depth -name \"settings.xml\" | xargs sed -i -e 's/JAVA_DIR/\/home\/$ME\/java/g';"
  
  cd "$HOME/java/apache-maven-3.2.5/conf"
  read -n100 -p "Enter the your Identity of LDAP: " USER_ID
  echo "";
  read -n100 -p "Enter the your Password of LDAP: " USER_PASS

  eval "find -depth -name \"settings.xml\" | xargs sed -i -e 's/IDENTITY_LDAP/$USER_ID/g';"
  eval "find -depth -name \"settings.xml\" | xargs sed -i -e 's/PASS_LDAP/$USER_PASS/g';"
}

configSettings;


INFO "Download jdk1.7 and copy it on $HOME/java keep folder name is jdk1.7"
INFO "Download eclipse and copy it on $HOME/java keep folder name is eclipse"
INFO "Thank you for used eXo tools ...";

eval "command gnome-terminal"

exit;



