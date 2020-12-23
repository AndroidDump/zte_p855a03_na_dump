#!/system/bin/sh

#case "$emmc_boot"
#    in "true")
#
#    ;;
#esac
if [ "x$(getprop persist.sys.ztelog.enable)" != "x1" ]; then
        exit 0
fi

#if [ "x$(getprop ro.build.type)" = "xuser" -a \
#     "x$(getprop init.svc.adbd)" != "xrunning" ]; then
#  exit 0
#fi

#if [ "x$(getprop persist.sys.ztelog.enable)" != "x1" ]; then
#        exit 0
#fi
storagePath="/data/local/vendor_logs/logcat/traceperf/"
timestamp=`date +'%Y-%m-%d-%H-%M-%S'`
logdir=$storagePath/$timestamp/

mkdir -p $logdir
cd $logdir

#echo 3000 > /sys/class/timed_output/vibrator/enable
date >> /d/tracing/trace_marker
kill -3 `busybox pidof system_server`
cat /d/tracing/trace > trace.txt
dumpsys > dumpstate.txt&

procrank >> meminfo.txt
cat /proc/meminfo >> meminfo.txt
cat /proc/buddyinfo >> meminfo.txt
cat /proc/version >> meminfo.txt
ps -t >> meminfo.txt

busybox ls -il -R /system > file.txt
busybox ls -il -R /data >> file.txt
lsof >> lsof.txt

cat /data/local/vendor_logs/logcat/logcat_main.txt.1 /data/local/vendor_logs/logcat/logcat_main.txt >> logcat_main.txt
cat /data/local/vendor_logs/logcat/logcat_system.txt.1 /data/local/vendor_logs/logcat/logcat_system.txt >> logcat_system.txt
cat /data/local/vendor_logs/logcat/logcat_events.txt.1 /data/local/vendor_logs/logcat/logcat_events.txt >> logcat_events.txt
busybox tar czf big.tgz file.txt logcat* lsof.txt meminfo.txt trace.txt
busybox rm -fr file.txt logcat* lsof.txt meminfo.txt trace.txt
sync
echo 1 > /d/tracing/buffer_size_kb
echo 4096 > /d/tracing/buffer_size_kb
#echo 3000 > /sys/class/timed_output/vibrator/enable
setprop debug.dumplog 0
