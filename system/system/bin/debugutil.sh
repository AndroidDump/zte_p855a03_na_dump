#!/system/bin/sh
#
# zte debug util
#BINDIR=/system/bin
#cd $BINDIR
#ln -s busybox [ > /dev/null 2>&1
#ln -s busybox test > /dev/null 2>&1
###########command lists#############
CMD_ENTERDOWNLOAD="enterdload"
CMD_ONEKEYLOGENABLE="enablelog"
CMD_ONEKEYLOGDISABLE="disablelog"
CMD_REBOOT="reboot"
CMD_PERFORMANCE="performance"
#####################################
echo "============debug util init==========="
utilpara=`getprop sys.zte.debugutil.data`
if busybox [ "$utilpara" == "" ];then	
	echo "debugutil not get any parameters, abort."
fi
if busybox [ "$utilpara" == "$CMD_ENTERDOWNLOAD" ];then	
	echo "cmd $utilpara starting..."
	setprop persist.sys.dlctrl 1
	echo "set download mode done!"
	sleep 1
	echo "sysrq-triggersystem will cause reboot soon!"
	echo c > /proc/sysrq-trigger
	sleep 1		
fi
if busybox [ "$utilpara" == "$CMD_ONEKEYLOGENABLE" ];then	
	echo "cmd $utilpara starting..."
	setprop persist.sys.dlctrl 1
	setprop persist.sys.ztelog.enable 1
	echo "set ztelog enable done."	
	sleep 1	
	echo "zte log full enable need resetart, executing reboot..."
	reboot	
fi
if busybox [ "$utilpara" == "$CMD_ONEKEYLOGDISABLE" ];then	
	echo "cmd $utilpara starting..."
	setprop persist.sys.dlctrl 0
	setprop persist.sys.ztelog.enable 0
	echo "set ztelog disable done."	
	sleep 1	
	echo "zte log full disable need resetart, executing reboot..."
	reboot	
fi
if busybox [ "$utilpara" == "$CMD_REBOOT" ];then	
	echo "cmd $utilpara starting..."	
	reboot
fi

if busybox [ "$utilpara" == "$CMD_PERFORMANCE" ];then	
	echo "cmd $utilpara starting..."	
	/system/bin/performance1&
	/system/bin/performance2&
fi
