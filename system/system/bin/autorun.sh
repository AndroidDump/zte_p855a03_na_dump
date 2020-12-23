#!/system/bin/sh

if busybox [ ! -d /system/bin/autorun ]
then
exit 1;
fi

echo $$ >/dev/cpuctl/apps/bg_non_interactive/tasks

scripts=`ls /system/bin/autorun`


for exe in $scripts
do
    echo "run $exe" 
    /system/bin/autorun/$exe>>/data/local/vendor_logs/logcat/$exe-log.txt 2>&1 &
done



