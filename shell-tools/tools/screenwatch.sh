#!/bin/bash
RUNCHECK=`ps aux | grep "$HOME/bin/screenwatch.sh" | grep -e "grep" | wc -l`;
if [ $RUNCHECK -lt 2 ]; then
ALLOCK=0
	PREVIOUSCONNTECTIONCOUNt=0
	while true; do
		sleep 15;
		locked=$( gnome-screensaver-command -q | grep " active" );
		if [ -n "$locked" -a $ALLOCK -eq 0 ]; then		
			xset dpms force off
			ALLOCK=1
		else
			ALLOCK=0
		fi
		
		SSHDCONNECTIONLIST=`netstat -na | grep ESTABLISHED | awk '{print $4,$5}' | grep "^[0-9]*\.[0-9]*\.[0-9]*.[0-9]*:22 "`;
		SSHDCONNECTIONCOUNT=`echo "$SSHDCONNECTIONLIST" | wc -m`;
		if [ $SSHDCONNECTIONCOUNT -gt 1 -a $SSHDCONNECTIONCOUNT -ne $PREVIOUSCONNTECTIONCOUNt ]; then
			IPLIST=`echo "$SSHDCONNECTIONLIST" | awk '{print $2}'`;
			`notify-send -t 30000 -u "critical" "SSHD connected" "$IPLIST"`;
			PREVIOUSCONNTECTIONCOUNt=$SSHDCONNECTIONCOUNT
		fi
	done
fi
