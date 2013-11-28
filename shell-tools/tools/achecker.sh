# The user login for achecker is: root pass: gtn
# has function or alias: use hasfc functionname. Ex: hasfs gedit
DIRS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if [ -f "/tmp/accessibility" ]; then
  EXO_FIRST="false";
else 
  EXO_FIRST="true";
  echo "$DIRS" > "/tmp/accessibility";
fi

ODLDIR=$(cat /tmp/accessibility);
echo "$DIRS" > "/tmp/accessibility";

if [ "$EXO_FIRST" == true ]; then
  sed -i -e "/exoenv.sh/ a\source $DIRS/achecker.sh" $HOME/.bashrc
elif [ "$DIRS" != "$ODLDIR" ]; then 
  eval "sed -i -e 's/source .*achecker.sh//g' $HOME/.bashrc";
  sed -i -e "/exoenv.sh/ a\source $DIRS/achecker.sh" $HOME/.bashrc;
fi

function hasfc() {
	command -v $1 >/dev/null && echo "Found" || echo "NotFound"
}

function INFO() {
 echo "[INFO] [$1]"
}

function startachecker() {
	if [ -e "/etc/init.d/mysql" ]; then 
		INFO "Stop mysql server install in system of linux....";
		sudo /etc/init.d/mysql stop
    echo "";
	fi
	sudo killall apache2;
	INFO "Start lampp server....";
	sudo /opt/lampp/lampp start
	sleep 1s;
	INFO "Default the acount administrator of achecker is(acc/pass): root/gtn";
	INFO "Open firefox browser ...";
	eval "firefox http://localhost/accessibility/checker/index.php &";
}

function acheckerHelp() {
  INFO "Welcome for use achecker client !!";
  INFO "If you want install the achecker client, you can use command: acheckerSetup";
  INFO "If you installed, but you want run achecker client, you can use command: achecker start";
  INFO "If you running achecker client, but you want stop it, you can use command: achecker stop";
  INFO "Display help for this shell script, you can use command: achecker help";
  echo "[NOTE] This file will auto source when you open Terminal. You do not need source it again. But, when you move this file, you must resource this file.";
}

function achecker() {
	if [ -n "$1" ]; then 
		if [ "$1" == "start" ]; then 
			startachecker;
		elif [ "$1" == "stop" ]; then 
			sudo /opt/lampp/lampp stop
			if [ -e "/etc/init.d/mysql" ] && [ "$2" == "" ]; then 
				eval "sudo /etc/init.d/mysql start &"
			fi
    else 
      acheckerHelp;
		fi
	fi 
}

function unzipAK() {
	if [ $(hasfc "unzip") == "Found" ]; then
		if [ -e "/opt/achecker.zip" ]; then
			cd /opt/
			eval "sudo unzip achecker.zip && cd lampp && sudo chmod 777 /opt/lampp/htdocs -R && startachecker"
		else 
			# sudo wget http://freehost -P /opt/ && unzipAK;
			echo "";
		fi
	else 
		eval "sudo apt-get install unzip && unzipAK"
	fi
}

function acheckerInstall() {
  INFO "Download lampp & achecker...";
  INFO "Enter username/password for download. It is storage eXo account (maybe same svn account).";
  echo "	(If you have not an account, you can keypress enter.)"
  read -n 100 -p "UserName: " user;
  if [-n "$user" ]; then
    read -s -n 100 -p "Password: " pass;
  fi
  echo "";
  if [ -n "$user" ] && [ -n "$pass" ] ; then
    sudo wget --http-user=$user --http-password=$pass http://storage.exoplatform.vn/ct/achecker.zip -P /opt/ && 
		     cd /opt/ && unzipAK;
  else 
    sudo wget --http-user=exo --http-password=eXo-secureVN http://storage.exoplatform.vn/ct/achecker.zip -P /opt/ && 
		     cd /opt/ && unzipAK;
  fi
}

function acheckerSetup() {
  eval "achecker stop not";
	if [ -e "/opt/lampp/htdocs/accessibility" ]; then
		eval "startachecker";
	elif [ -e "/opt/achecker.zip" ]; then
		unzipAK;
	else
     read -n1 -p "Do you  want to install xampp?(y/n): " yesn;
     if [ "$yesn" == "y" ] || [ "$yesn" == "Y" ]; then
       echo "";
		   eval "acheckerInstall";
     fi
	fi
}

function welcome() {
  if [ "$EXO_FIRST" == "true" ]; then
    acheckerHelp;
    if [ -e "/opt/lampp/htdocs/accessibility" ]; then
      read -n1 -p "Do you  want to run achecker?(y/n): " yesn;
      if [ "$yesn" == "y" ] || [ "$yesn" == "Y" ]; then 
        echo "";
        eval "startachecker";
      fi
    else 
      read -n1 -p "Do you  want to install xampp?(y/n): " yesn;
      if [ "$yesn" == "y" ] || [ "$yesn" == "Y" ]; then
        echo "";
 		    eval "acheckerInstall";
      fi
    fi
    echo "";
  fi
}

welcome;




