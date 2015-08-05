OLDVS=`mvn --version | grep 'Apache Maven' | awk '{print $3}'`;
OLDMVDIR=`mvn --version | grep 'Maven home' | awk '{print $3}'`;

cd $JAVA_DIR;
if [ ! -n "$MVVS" ]; then
  MVVS="3.2.3";
fi

if [ "$MVVS" != "$OLDVS" ]; then
  INFO "";
  INFO "=========Upgrade maven from $OLDVS to $MVVS============="
  INFO "";
  INFO "";
fi

function unzipMaven() {
	if [ $(hasfc "unzip") == "Found" ]; then
		if [ -e "/$JAVA_DIR/apache-maven-$MVVS-bin.zip" ]; then
      INFO "unzip apache-maven-$MVVS-bin.zip";
			eval "unzip apache-maven-$MVVS-bin.zip"
		else 
      INFO "Download apache-maven-$MVVS-bin.zip";
      eval "wget http://www.eu.apache.org/dist/maven/maven-3/$MVVS/binaries/apache-maven-$MVVS-bin.zip && unzipMaven"
		fi
	else
    INFO "Install unzip";
		eval "sudo apt-get install unzip && unzipMaven"
	fi
}

function confMv() {
  INFO "Backup setting";
  eval "mv $JAVA_DIR/apache-maven-$MVVS/conf/settings.xml $JAVA_DIR/apache-maven-$MVVS/conf/settings_b.xml"
  INFO "cp $OLDMVDIR/conf/settings.xml $JAVA_DIR/apache-maven-$MVVS/conf/settings.xml";
  eval "cp $OLDMVDIR/conf/settings.xml $JAVA_DIR/apache-maven-$MVVS/conf/settings.xml";
}

function goodbye() {
  INFO "Maven $MVVS upgraded OK.";
  INFO "Thank you for upgrade maven to $MVVS ...";
  sleep 3s;
}

if [ "$MVVS" != "$OLDVS" ]; then
  eval "unzipMaven && confMv && goodbye && gnome-terminal && exit;";
fi

