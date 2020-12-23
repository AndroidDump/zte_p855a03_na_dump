#!/system/bin/sh
######################
#used for batinfo record
#####################
SYSDIR=/cache
LOGDIR=$SYSDIR/logs
BINDIR=/system/bin
BATINFODIR=$LOGDIR/batinfo

function func1()
{
	CAP=`cat /sys/class/power_supply/battery/capacity`
	STATUS=`cat /sys/class/power_supply/battery/status`
	CURRENT_NOW=`cat /sys/class/power_supply/battery/current_now`
	INPUT_CURRENT_NAX=`cat /sys/class/power_supply/battery/input_current_max`
	INPUT_CURRENT_TRIM=`cat /sys/class/power_supply/battery/input_current_trim`
	TEMP=`cat /sys/class/power_supply/battery/temp`
	VOLTAGE_NOW=`cat /sys/class/power_supply/battery/voltage_now`
	TIME=`date +"%m-%d %H:%M:%S"`
	echo "$TIME $CAP $TEMP $VOLTAGE_NOW $CURRENT_NOW ($INPUT_CURRENT_NAX/$INPUT_CURRENT_TRIM) $STATUS" >> $BATINFODIR/batinfo.txt
}

function func2()
{
	dmesg -c | busybox grep -e "CHG" -e "BMS" >> $BATINFODIR/batinfo.txt &
	$BINDIR/busybox find $BATINFODIR -size +2048k | $BINDIR/busybox grep batinfo.txt
    case "$?" in
       0)   echo "linux 2048k $?"
            mv $BATINFODIR/batinfo.3.txt $BATINFODIR/batinfo.4.txt
            mv $BATINFODIR/batinfo.2.txt $BATINFODIR/batinfo.3.txt
            mv $BATINFODIR/batinfo.1.txt $BATINFODIR/batinfo.2.txt
            mv $BATINFODIR/batinfo.txt $BATINFODIR/batinfo.1.txt
	;;
    esac 
}

function main()
{
	mkdir -p $BATINFODIR
	$BINDIR/busybox chmod -R 755 $BATINFODIR/

	echo "++++++++++++++++++++++++++++++++++++++" >> $BATINFODIR/charger_monitor.txt
	echo "++++++++++++++++++++++++++++++++++++++" >> $BATINFODIR/batinfo.txt
	#add for charger_monitor log output
	logcat -f $BATINFODIR/charger_monitor.txt -r1024 -n4 -v threadtime -s charger_monitor:V &

	echo 5000 > /sys/module/qpnp_charger/parameters/heartbeat_ms

	while true
	do	 
		func2
		sleep 5
	done
}

#####Main####
main

