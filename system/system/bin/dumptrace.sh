#!/system/bin/sh

trace_log_dir=/data/local/vendor_logs
if [ "x$(getprop persist.sys.ztelog.enable)" != "x1" ]; then
    exit 0
fi

MemTotalStr=`cat /proc/meminfo | /system/bin/grep MemTotal`
MemTotal=${MemTotalStr:16:8}
if [ $MemTotal -lt 800000 ]; then
    echo "dumptracer.sh exit becasue MemTotal = $MemTotal"
    exit 0
fi

systracing_is_running=`cat /d/tracing/tracing_on`
if [ "$systracing_is_running" -eq "0" ]; then
    exit 0
fi
local reason=`getprop debug.systrace.reason`

local jank=`getprop init.svc.jankdumpsystrace`
if [ "$jank" = "running" ] ; then
        reason="jank"
fi

local tt=`date +%G%m%d_%H%M%S`
local is_dualsystem=`getprop ro.feature.for_zte_cell`
local trim_reason=${reason/\//\.}
local trace_file_name=systrace.${tt}.${trim_reason}.txt

if [ "$is_dualsystem" = "true" ] ; then
	local file=/data/local/logs0/logcat/$trace_file_name
	cd /data/local/logs0/logcat/
else
	local file=${trace_log_dir}/logcat/$trace_file_name
	cd ${trace_log_dir}/logcat/
fi
#getenforce|grep Enforcing

#if $busybox [ $? -eq 0 ]; then
#    echo "enforceing..."
#cat /d/tracing/trace > $file
#else
#    atrace -c -b 8192 -t 3600000 gfx wm view webview mdss am res app sched freq dalvik input message binder action memreclaim --async_dump -z -o $file
#fi
time=`date "+%T.%N"`
echo "B|0000|***systrace dump timestamp is $time***" > /d/tracing/trace_marker
atrace2 --async_dump -z -o $file

logcat -b events -d > events.txt
logcat -d > mainsystem.txt

mmpid=`pidof com.tencent.mm`
cat /proc/$mmpid/maps >> mainsystem.txt
cat /d/kgsl/proc/$mmpid/mem >> mainsystem.txt
#

#
# add for display dumpsys
#
if [ ! -n "$trim_reason" ]; then
    rm -fr dumpsys_screenshots.txt
    echo "begin time: "`date +%G%m%d_%T.%N` >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys window" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 window -a >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys display" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 display -a >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys SurfaceFlinger" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 SurfaceFlinger -a >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys activity broadcasts" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 activity broadcasts >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys activity activities" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 activity activities >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys activity service SystemUIService" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 activity service SystemUIService >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys alarm" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 alarm -a >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    echo "        dumpsys jobscheduler" >> dumpsys_screenshots.txt
    echo "----------------------------------------" >> dumpsys_screenshots.txt
    dumpsys -t 30 jobscheduler -a >> dumpsys_screenshots.txt
    echo "end time: "`date +%G%m%d_%T.%N` >> dumpsys_screenshots.txt
    chmod 755 dumpsys_screenshots.txt
fi


echo $trim_reason | grep "watchdog"
if [ $? -eq 0 ]; then
    echo "----------------------------------------" >> dumpsys_log.txt
    echo "        dumpsys activity all" >> dumpsys_log.txt
    echo "----------------------------------------" >> dumpsys_log.txt
    dumpsys -t 30 activity -v all >> dumpsys_log.txt
    echo "----------------------------------------" >> dumpsys_log.txt
    echo "        dumpsys activity service all" >> dumpsys_log.txt
    echo "----------------------------------------" >> dumpsys_log.txt
    dumpsys -t 30 activity service all >> dumpsys_log.txt
    echo "----------------------------------------" >> dumpsys_log.txt
    echo "        dumpsys activity provider all" >> dumpsys_log.txt
    echo "----------------------------------------" >> dumpsys_log.txt
    dumpsys -t 30 activity provider all >> dumpsys_log.txt

    tar zcf $file.tar.gz $trace_file_name events.txt mainsystem.txt dumpsys_log.txt /d/binder
    rm -fr $file events.txt mainsystem.txt dumpsys_log.txt
else
    #tar zcf $file.tar.gz $file events.txt mainsystem.txt
    tar zcf $file.tar.gz $trace_file_name events.txt mainsystem.txt
    rm -fr $file events.txt mainsystem.txt
fi
chmod 755 $file.tar.gz

mkdir /sdcard/systrace/

funi=0
if [ "$is_dualsystem" = "true" ] ; then
	for file in `ls /data/local/logs0/logcat/systrace.*.gz | sort -nr`
	do
	funi=`expr $funi + 1`
	if [ "$funi" -gt "3" ]; then
	  #mv $file /sdcard/systrace/
          rm -fr $file
	  echo $file
	fi
	done
else
	for file in `ls ${trace_log_dir}/logcat/systrace.*.gz | sort -nr`
	do
	funi=`expr $funi + 1`
	if [ "$funi" -gt "3" ]; then
          if [ "x$(getprop persist.backtrace.threshold)" != "x" ]; then
	    mv $file /sdcard/systrace/
          fi
          rm -fr $file
	  echo $file
	fi
	done
fi
funi=0
for file in `ls /sdcard/systrace/systrace.*.gz | sort -nr`
do
funi=`expr $funi + 1`
if [ "$funi" -gt "60" ]; then
  rm -fr $file
  echo $file
fi
done

#for tp test  rzl
funi=0
for file in `ls /cache/logs/logcat/get_noisedata*.txt | sort -nr`
do
funi=`expr $funi + 1`
if [ "$funi" -gt "60" ]; then
  rm -fr $file
  echo $file
fi
done
/system/bin/get_tp_noise&

setprop debug.systrace.reason ""

