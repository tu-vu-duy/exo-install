# Note:
# storage files .deb when install in: /var/cache/apt/archives
####
# find -name "*.sql" -o -name "*.ksh" -o -name "*.ini"
####
# apt-fast --> dau tien phai cai axel truoc. (/Dropbox/tools/apt-fast)
# download http://www.mattparnell.com/linux/apt-fast/apt-fast.sh
# copy it to /usr/bin/
# sudo mv apt-fast.sh apt-fast
# sudo chmod +x apt-fast
####
# Quick download
# apt-get install axel 
# ex: axel -n 5  http://user:pass@intranet.exoplatform.org/file.iso
# ex: axel -n 3 -s 5242880 http://download.com/my.iso 
####
# wget –i download.txt
# echo "$*"; --> tra ve toan bo cac gia tri nhap vao cua function = 1 string
####
# read -s -n100 -p "Hit a key " keypress
# echo "Keypress was "\"$keypress\""."
# -s option means do not echo input.
# -n N option means accept only N characters of input.
# -p option means echo the following prompt before reading input.
####
# all value input $*
## change ip
# sudo ifconfig eth0 192.168.1.5 netmask 255.255.255.0 up

# all complate function in: /etc/bash_completion

function installeXo() {

	cd /tmp
  wget http://nchc.dl.sourceforge.net/project/diffuse/diffuse/0.4.6/diffuse_0.4.6-1_all.deb
  sudo dpkg -i diffuse*.deb
	sudo apt-get install chrome-browser;
	#sudo apt-get install rar;
	sudo apt-get install zip;
	sudo apt-get install unzip;
	#sudo apt-get install filezilla;
	sudo apt-get install skype
	sudo apt-get install vlc vlc-plugin-pulse mozilla-plugin-vlc;
	#sudo apt-get install gimp gimp-data gimp-plugin-registry gimp-data-extras;
	sudo apt-get install compizconfig-settings-manager;
	#sudo apt-get install cheese;
	sudo apt-get install gnome-shell;
	sudo apt-get install gnome-panel;
	#sudo apt-get install nautilus-dropbox;
	sudo apt-get install gnome-tweak-tool;
	#sudo apt-get install subversion;
	sudo apt-get install pidgin;
	sudo apt-get install axel;
	sudo apt-get install git;
	sudo apt-get install geany;
	sudo apt-get install avant-window-navigator;
	sudo apt-get install synapse;
	sudo apt-get install node-less;
	sudo apt-get install mysql-server mysql-client;
	sudo apt-get install mysql-workbench;
	sudo apt-get install mysql-query-browser;
	sudo apt-get install emma;
	sudo apt-get -f install;
}

function installApp() {
	cd /tmp
	wget http://nchc.dl.sourceforge.net/project/diffuse/diffuse/0.4.6/diffuse_0.4.6-1_all.deb
	sudo dpkg -i diffuse*.deb
	sudo apt-get install axel;

	wget http://www.mattparnell.com/linux/apt-fast/apt-fast.sh
	cp apt-fast.sh /usr/bin/
	mv /usr/bin/apt-fast.sh /usr/bin/apt-fast
	chmod +x /usr/bin/apt-fast

	sudo apt-cache search chrome browser;
	sudo apt-fast install chrome-browser;
	sudo apt-fast install rar;
	sudo ln -fs /usr/bin/rar /usr/bin/unrar;
	sudo apt-fast install zip;
	sudo apt-fast install unzip;
	#sudo apt-fast install filezilla;

	sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner";
	sudo add-apt-repository ppa:lucid-bleed/ppa;
	sudo add-apt-repository ppa:matthaeus123/mrw-gimp-svn;
	sudo apt-fast update;
	sudo apt-fast install skype
	sudo apt-fast install vlc vlc-plugin-pulse mozilla-plugin-vlc;
	sudo apt-fast install compizconfig-settings-manager;
	#sudo apt-fast install cheese;
	sudo apt-fast install gnome-shell;
	sudo apt-fast install gnome-panel;
	sudo apt-fast install nautilus-dropbox;
	sudo apt-fast install gnome-tweak-tool;
	#sudo apt-fast install subversion;
	#sudo apt-fast install pidgin;
	sudo apt-fast install git;
	sudo apt-fast install geany;
	sudo apt-fast install avant-window-navigator;
	sudo apt-fast install synapse;
	sudo apt-fast install gimp gimp-data gimp-plugin-registry gimp-data-extras;
	sudo apt-fast install mysql-server mysql-client;
	sudo apt-fast install mysql-workbench;
	sudo apt-fast install mysql-query-browser;
  sudo apt-fast install emma;
	# sudo apt-fast install jenkins;
	installss;
}



URL_CA="";
TYPE_CA="lx";
ST_CA=1;
ID_CA="";
DIR_CA="/media/Datas/datas/temps";
function getFileHTML() {
  OLD="$PWD";
  dir=$DIR_CA;
  URL=$URL_CA;
  type=$TYPE_CA;
  id=$ID_CA;
  st=$ST_CA;
  end=1;
  tmp="";
  isHelp=true;
  for arg  in "$@" 
    do
 		  isHelp=false
      if [ ${#arg} -gt 10 ]; then
        URL="${arg/url=/}";
      elif [ $(expr match $arg "type=") -gt 0 ]; then 
        type="${arg/type=/}";
      elif [ $(expr match $arg "id=") -gt 0 ]; then 
        id="${arg/id=/}";
      elif [ $(expr match $arg "st=") -gt 0 ]; then 
        st="${arg/st=/}";
      elif [ $(expr match $arg "end=") -gt 0 ]; then 
        end="${arg/end=/}";
      elif [ $(expr match $arg "dir=") -gt 0 ]; then 
        dir="${arg/dir=/}";
      fi
  done
	if [ $isHelp == true ]; then 
		INFO "Command: getFileHTML dir= st= end= url= type= id=";
		return
	fi
  INFO "$dir $st $end $URL $type $id";
  cd "$dir";
  for (( i = $st ; i <= $end ; i++ ))
    do
      if [ "$type" == "360" ]; then
        INFO "Download: $URL${i}&fid=$id";
        wget "$URL${i}&fid=$id";
      elif [ "$type" == "lx"  ]; then 
        INFO "Download: $URL${i}.html";
        wget "$URL${i}.html";
      else
         if [ $(expr match $URL "ID") -gt 0 ]; then
            tmp="${URL/ID/$i}";
         fi
        INFO "Download: $tmp";
        wget "$tmp";
      fi
  done
  URL_CA=$URL;
  TYPE_CA=$type;
  ID_CA=$id;
  ST_CA=$((end + 1));
  DIR_CA=$dir;
  cd "$OLD"
}


function getFlicker() {
hmUrl="http://www.flickr.com/photos/ngac_nhien_chua/";

#donload page

 for (( i = 1 ; i <= 6 ; i++ ))
    do
      if [ "$i" == "1" ]; then
         wget "$hmUrl";
      else
         wget "${hmUrl}page${i}/";
      fi
   done

}
# 

function getfiletypes() {
  fileType="'$1'";
  fileType="${fileType// /' '}"
  fileType=($fileType);
  i=0;
  for X in "${fileType[@]}"; do
    if [ $i == 0 ]; then
      fileType="-name $X";
      i=1;
    else 
      fileType="$fileType -o -name $X";
    fi
  done 
  echo " -type f $fileType";
}

function findgrep() {
  inp="'$1'";
  local tp=`eval "getfiletypes $inp"`;
  if [ -n "$tp" ]; then 
    key="$2";
    INFO "find $tp | xargs grep --color=always '$key'";
    eval "find $tp | xargs grep --color=always '$key'";
  fi
}

function findgrep_() {
  inp="'$1'";
  local tp=`eval "getfiletypes $inp"`;
  if [ -n "$tp" ]; then 
    key="$2";
    finds=`eval "find $tp"`;
    INFO "find $tp";

    eval "finds=($finds)"

    for X in "${finds[@]}"; do
      if [ -n "$X" ]; then 
        if [ -n "$3" ]; then 
          grep --color=always  "$key" "$X" > '$3';
        else
          kq=`grep --color=always  "$key" "$X"`;
          if [ -n "$kq" ]; then
            echo "";
            echo "File: $X";
            echo "$kq";
          fi
        fi
      fi
    done
  fi
}


function findopen() {
  inp="'$1'";
  local tp=`eval "getfiletypes $inp"`;
  if [ -n "$tp" ]; then 
	  finds=`eval "find $tp"`;
	  INFO "find $tp";

	  eval "finds=($finds)"

	  for X in "${finds[@]}"; do
		if [ -n "$X" ]; then 
		  echo "Open file: $X";
		  eval "geany $X &";
		fi
	  done
  fi
}

# st.*end
function findsed() {
  rg=$1;
  by="";
  if [ -n "$2" ]; then 
    by=$2;
  fi
  na="ketqua.sh";
  if [ -n "$3" ]; then 
    na=$3;
  fi

  INFO "find -depth -name \"$na\" | xargs sed -i -e 's/$rg/$by/g';"
  eval "find -depth -name \"$na\" | xargs sed -i -e 's/$rg/$by/g';"
}


INFO "getFileHTML findgrep file-types grep-key file-storage; findsed re-word re-by file-types; findopen file-types";


function crFolder() {
  st=$1;
  end=$2;
  fdn=$3;
  Dir="$PWD";
  if [ -n "$4" ]; then
    Dir=$4;
  fi
  for (( i = $st ; i <= $end ; i++ ))
   do
  # create folder
      eval "mkdir -p -m 777 $Dir/$fdn$i"
  done
}

_crFolder ()   #  By convention, the function name
{                 #+ starts with an underscore.

  # Pointer to current completion word.
  # By convention, it's named "cur" but this isn't strictly necessary.
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="--start= --end= --folder-name= --folder-dir= --help"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}

complete -F "_crFolder" -o "default" "crFolder"

function createGit() {
	if [ -n "$1" ];then
		folder=$1;
		mkdir -m 777 $folder;
		cd $folder;
		git init;
		git add .;
		git commit -m 'first commit';
		git remote add origin git@github.com:tuvd08/$folder.git
		git push -u origin master
	else
		INFO "createGit folder-repo"
	fi
}

function gedit() {
	eval "geany $* &";
}

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

function hctinfo()
{
        OPTSTRING="a:A:d:D:h:H:i:I:g:G:m:M:o:O:p:P:v:V:";
        while getopts ${OPTSTRING} option
        do
                case ${option} in
                        h|H)    echo "Help $OPTARG";;
                        v|V)    echo "version $OPTARG";;
                        a|A)    echo "ADMIN_STAT $OPTARG";;
                        i|I)    echo "IMAGE $OPTARG";;
                        g|G)    echo "GROUP $OPTARG";;
                        d|D)    echo "DESC $OPTARG";;
                        m|M)    echo "MOD $OPTARG";;
                        o|O)    echo "OPER_STAT $OPTARG";;
                        p|P)    echo "PACKS $OPTARG";;
                        ?)      echo "WTF? Way to go, dumbass";;
                esac
        done
        shift $(( OPTIND - 1 ));
        unset OPTSTRING;
        unset OPTIND;
        #unset hctinfo;
}

function configSettings() {
  ME=$(whoami);

  INFO "Configuration settings.xml of maven";
  INFO "If you configuration error, you can open the file $HOME/java/apache-maven-3.0.4/conf/settings.xml and manual configuration";

  #cd "$HOME/java/apache-maven-3.0.4/conf"
  eval "find -depth -name \"settings.xml\" | xargs sed -i -e 's/JAVA_DIR/\/home\/$ME\/java/g';"
  
  #cd "$HOME/java/apache-maven-3.0.4/conf"
  read -n100 -p "Enter the your Identity of LDAP: " USER_ID
  echo "";
  read -n100 -p "Enter the your Password of LDAP: " USER_PASS

  eval "find -depth -name \"settings.xml\" | xargs sed -i -e 's/IDENTITY_LDAP/$USER_ID/g';"
  eval "find -depth -name \"settings.xml\" | xargs sed -i -e 's/PASS_LDAP/$USER_PASS/g';"
}
