#!/system/bin/sh
sleep 120
busybox ls -i -l -R /system > /data/local/vendor_logs/logcat/hotfile.system.txt
busybox ls -i -l -R /data > /data/local/vendor_logs/logcat/hotfile.data.txt
top -m 8 -d 180 -t >> /data/local/vendor_logs/logcat/cpu.txt&
while true
do
sleep 180
#busybox top -d 60 -n 10 1>>/data/local/vendor_logs/logcat/cpu.txt
#cat /proc/msm_pm_stats >>$logfile
l=`busybox du -s  /data/local/vendor_logs//logcat/trace.0 | busybox awk '{print $1}'`
if busybox [ "$l" -gt "4096" ] ;then
    busybox rm -fr /data/local/vendor_logs/logcat/trace.5.tar.gz
    busybox mv /data/local/vendor_logs/logcat/trace.4.gz /data/local/vendor_logs/logcat/trace.5.gz
    busybox mv /data/local/vendor_logs/logcat/trace.3.gz /data/local/vendor_logs/logcat/trace.4.gz
    busybox mv /data/local/vendor_logs/logcat/trace.2.gz /data/local/vendor_logs/logcat/trace.3.gz
    busybox mv /data/local/vendor_logs/logcat/trace.1.gz /data/local/vendor_logs/logcat/trace.2.gz
    cd /data/local/vendor_logs/logcat/
    busybox tar zcf /data/local/vendor_logs/logcat/trace.1.gz trace.0
    echo "" > /data/local/vendor_logs/logcat/trace.0
    sync
fi
date >> /data/local/vendor_logs/logcat/cpu.txt
done
