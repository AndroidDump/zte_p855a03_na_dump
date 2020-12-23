#!/system/bin/sh

#local funi=1
while true
do
	date >> /data/local/vendor_logs/logcat/mem.txt
	procrank | busybox head -10 >> /data/local/vendor_logs/logcat/mem.txt
	sleep 600
done
