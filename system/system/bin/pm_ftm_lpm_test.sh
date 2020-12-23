#!/system/bin/sh
#this .sh is used to test current while devices enter LPM in FTM

#how to run this .sh
#adb push ftmlpm.sh /data/
#adb shell
#cd /data
#chmod 777 ftmlpm.sh
#./ftmlpm.sh

setprop debug.factory.powertest 0
setprop debug.factory.powerkey 0
echo "pm_ftm_lpm_test.sh enter" > /dev/kmsg
target=`getprop ro.board.platform`
if [ -f "/sys/class/backlight/panel0-backlight/brightness" ];then
    if [ x"$1" != "xphone" ] ; then
        echo "pm_ftm_lpm_test.sh single board test" > /dev/kmsg
        echo 0 > /sys/class/power_supply/battery/charging_enabled
    else
        echo "pm_ftm_lpm_test.sh whole phone test" > /dev/kmsg
    fi
    echo "pm_ftm_lpm_test.sh 1-1 " > /dev/kmsg
    input keyevent POWER
    echo "pm_ftm_lpm_test.sh 1-2" > /dev/kmsg
    setprop debug.factory.powerkey 1
else
    echo "pm_ftm_lpm_test.sh 1-3" > /dev/kmsg
    echo 0 > /sys/class/leds/lcd-backlight/brightness
    echo 4 > /sys/class/graphics/fb0/blank
    echo "pm_ftm_lpm_test.sh 1-4" > /dev/kmsg
fi
echo "pm_ftm_lpm_test.sh 2" > /dev/kmsg
echo mmi > /sys/power/wake_unlock
echo PowerManagerService.Display > /sys/power/wake_unlock
echo PowerManagerService.WakeLocks > /sys/power/wake_unlock
echo mem > /sys/power/autosleep
echo "pm_ftm_lpm_test.sh 3" > /dev/kmsg
setprop debug.factory.powertest 1
