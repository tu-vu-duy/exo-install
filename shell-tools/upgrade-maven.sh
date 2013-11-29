cd $JAVA_DIR;

INFO "";
INFO "=========Upgrade maven to 3.1.1============="
INFO "";
INFO "";

function unzipMaven() {
	if [ $(hasfc "unzip") == "Found" ]; then
		if [ -e "/$JAVA_DIR/apache-maven-3.1.1-bin.zip" ]; then
      INFO "unzip apache-maven-3.1.1-bin.zip";
			eval "unzip apache-maven-3.1.1-bin.zip"
		else 
      INFO "Download apache-maven-3.1.1-bin.zip";
      eval "wget http://www.eu.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.zip && unzipMaven"
		fi
	else
    INFO "Install unzip";
		eval "sudo apt-get install unzip && unzipMaven"
	fi
}

function confMv() {
  INFO "Backup setting";
  eval "mv $JAVA_DIR/apache-maven-3.1.1/conf/settings.xml $JAVA_DIR/apache-maven-3.1.1/conf/settings_b.xml"
  INFO "Find old configuration maven3.0";
  MV=`find -maxdepth 1 -type d -name '*maven*3.0*'`;
  MV=`echo $MV | awk '{print $1}'`
  OLMV=$JAVA_DIR/${MV/\.\//};
  INFO "cp $OLMV/conf/settings.xml $JAVA_DIR/apache-maven-3.1.1/conf/settings.xml";
  eval "cp $OLMV/conf/settings.xml $JAVA_DIR/apache-maven-3.1.1/conf/settings.xml";
}

function goodbye() {
  INFO "Maven 3.1.1 upgraded OK.";
  INFO "Thank you for upgrade maven to 3.1.1 ...";
  sleep 3s;
}

eval "unzipMaven && confMv && goodbye && gnome-terminal && exit;";

