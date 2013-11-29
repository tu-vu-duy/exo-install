
function cmall() {
	pwd_=$PWD;
  cm=$1;
  if [ -n "$cm" ]; then
    for X in `ls --color=no`; 
      do
        if [ -e "$pwd_/$X/" ]; then
          cd "$pwd_/$X";
          INFO "$PWD: $cm";
          eval "$cm"; 
        fi
    done
  fi
  cd $pwd_;
}

function gitcmall() {
	cm=$1;
	cmall "git $cm"
}

function cmtaball() {
	cm=$1;
	cm="echo \"$cm && echo '' > ~/.command.sh && exit 0;\" > ~/.command.sh && gnome-terminal";
	cmall "$cm";
}

function cmbuildall() {
	pwd_=$PWD;
	pros="($1)";
	eval "pros=$pros"
	cm=$2;
 for X in ${pros[@]}
	do
		INFO "$X $cm";
		eval "echo \"cd $X && $cm; echo '' > ~/.command.sh && exit 0;\" > ~/.command.sh && gnome-terminal";
		sleep 1s;
 done
  cd $pwd_;
}

function cmprojectall() {
	pwd_=$PWD;
	pros="($1)";
	eval "pros=$pros"
	cm=$2;
 for X in ${pros[@]}
	do
		INFO "$pwd_/$X $cm";
		eval "cd $pwd_/$X && $cm;";
		sleep 1s;
 done
  cd $pwd_;
}


echo "Function support: makefeature 'feature-name' 'projects', checkoutFeature 'feature-name', eclipseAll, buildAll, changeVersion 'new-version' ";

function makefeature() {
	feature="$1";
	projects="($2)";
	pwd_=$PWD;
	
	cd $EXO_PROJECTS_SRC
	mkdir -p -m 777 features;
	cd features
	mkdir -p -m 777 $feature;

	eval "pros=$projects"
	 for X in ${pros[@]}
		do
			cd $feature;
			INFO "git clone git@github.com:exodev/${X}.git";
			eval "git clone git@github.com:exodev/${X}.git && cd ${X} && git co feature/$feature origin/feature/$feature";
			sleep 1s;
	 done
	cd $feature;
	eval "git clone git@github.com:tu-vu-duy/platform-tomcat-standalone.git";
	eval "git clone git@github.com:exoplatform/platform-private-distributions.git";
  cd $pwd_;
}

function eclipseAll() {
	cmall "mvneclipse -T2C";	
}

function buildAll() {
	pwd_=$PWD;
	plf="platform platform-private-distributions";
	PRJ=`ls --color=no`;
	eval "PRJ=($PRJ)";
	for X in ${PRJ[@]}
		do
			if [ -e "$pwd_/$X/" ] && [ "$X" != "platform/" ] && [ "$X" != "platform-private-distributions/" ]; then
				cd "$pwd_/$X";
				INFO "$PWD: mvninstall $*";
				eval "mvninstall $*"; 
			fi
	done

	eval "cd $pwd_/platform && mvninstall $* && cd $pwd_/platform-private-distributions  && mvninstall";

	cd $pwd_;
}

function checkoutFeature() {
	pwd_=$PWD;
	if [ -e "$pwd_/$1/" ]; then
		cd "$1";
	fi
	feature="$1";
	gitcmall "checkout feature/$feature"
	cd $pwd_;
}

function changeVersion() {
	eval "mvn --batch-mode release:update-versions -DdevelopmentVersion=$1";
}

function helpsocial() {
 echo "";
 INFO "Install:";
 INFO "";
 INFO "1/ edit file exoenv.sh from java folder";
 INFO "2/ add new line: source "$JAVA_DIR/social-tools.sh";";
 INFO "3/ cp this file social-tools.sh for java folder for tools";
 INFO "";
 INFO "Detail functions:";
 INFO "";
 INFO "1/ makefeature 'feature-name' 'projects'";
 INFO "		feature-name ==> feature-name: activity-type";
 INFO "		projects ==>> tat ca nhung projects lien quan";
 INFO "		ex: makefeature 'activity-type' 'forum commons social platform ecms wiki '";
 INFO "";
 INFO "2/ checkoutFeature 'feature-name' vd: checkoutFeature 'activity-type'";
 INFO "";
 INFO "3/ eclipseAll ==> lenh nay se chay mvn eclipse:eclipse cho tat ca cac projects trong 1 folder";
 INFO "";
 INFO "4/ buildAll ==> lenh nay se chay mvninstall cho tat ca cac projects trong 1 folder";
 INFO "";
 INFO "5/ changeVersion 'new-version' ==> change version trong POM.xml cua project";
 INFO "		viet con 5 de tien cho anh re-version";
 INFO "		vd: changeVersion '4.0.0.Alpha-filter-SNAPSHOT'";
 INFO "";
 INFO "6/ gitcmall ==> lenh nay se ap dung chay lenh git cho tat ca cac projects trong folder";
 INFO "	  vd: gitcmall 'pull origin'";
 INFO "	  Voi lenh gitcmall, ban co the tuy bien rong hon ";
 INFO "	  vd: gitcmall 'checkout feature/activity-filter && mvninstall'";
 INFO "	  voi cach danh tren, ban se ko phai build cac projects ko co branch feature/activity-filter, ";
 INFO "	  no chi build cac projects co branch feature/activity-filter trong folder.";
 INFO "";
 INFO "7/ cmprojectall 'projects' 'commands' ==> chay lenh cac projects vd: ";
 INFO "		vd: cmprojectall 'commons social forum platform' 'git pull origin && mvn clean install -Pexo-private'";
 INFO "		no se chay lan luot cac project theo lenh sau do, theo dung thu tu liet ke";
 INFO "";
 INFO "Tuy bien lenh cmprojectall de su dung het kha nang cua no theo y ban.";
 echo "";
}
