alias cdhome="cd ~"
alias cdwinhome="cd $USER_HOME"
alias cdback='cd  $OLDPWD'

alias mvnrepoclean="rm -rf $M2_REPO/org/exoplatform/* $M2_REPO/javax/portlet/*"

alias cdprs="cd $EXO_PROJECTS_SRC"
alias mdfalias="gedit $TOOL_HOME/exoalias.sh &"

#alias mvnclin="mvn clean install -Pexo-private"
#alias mvninstall="mvn clean install -Dmaven.test.skip=true -Pexo-private"
#alias mvnbuildnottc="mvn clean install -Dmaven.test.skip=true -P !pkg-tomcat -Pexo-private"
#alias mvnnottomcat="mvn clean install -P !pkg-tomcat -Pexo-private"
#alias mvntomcattarget="mvn clean install -Dgatein.working.dir=target -Pexo-private"
#alias mvntest="mvn clean test -Pexo-private"
#alias mvneclipse="mvn eclipse:eclipse -Pexo-private"
#alias mvnclean="mvn eclipse:clean -Pexo-private"

alias opsrc="nautilus $EXO_PROJECTS_SRC"
alias opwkd="nautilus $EXO_WORKING_DIR"
alias opjava="nautilus $JAVA_DIR"
