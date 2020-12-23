#!/system/bin/sh
#this .sh is used test current while devices runs at full speed with all CPUs in FTM



stop mpdecision
echo "stop mpdecision"
echo "scaling_min_freq before set" 
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online

echo "scaling_min_freq 0 after set" 
max=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
echo $max > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

echo "scaling_min_freq 1 after set" 
max=`cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq`
echo $max > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq


echo "scaling_min_freq 2 after set" 
max=`cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_max_freq`
echo $max > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq

echo "scaling_min_freq 3 after set" 
max=`cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_max_freq`
echo $max > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq
cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

echo "disable 0 idle --> PC"
echo 0 > /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu0/power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
cat /sys/module/msm_pm/modes/cpu0/retention/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu0/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu0/wfi/idle_enabled




echo "disable 1 idle --> PC"
echo 0 > /sys/module/msm_pm/modes/cpu1/power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu1/power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
cat /sys/module/msm_pm/modes/cpu1/retention/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu1/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu1/wfi/idle_enabled


echo "disable 2 idle --> PC"
echo 0 > /sys/module/msm_pm/modes/cpu2/power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu2/power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
cat /sys/module/msm_pm/modes/cpu2/retention/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu2/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu2/wfi/idle_enabled


echo "disable 3 idle --> PC"
echo 0 > /sys/module/msm_pm/modes/cpu3/power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu3/power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu3/retention/idle_enabled
cat /sys/module/msm_pm/modes/cpu3/retention/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
cat /sys/module/msm_pm/modes/cpu3/standalone_power_collapse/idle_enabled
echo 0 > /sys/module/msm_pm/modes/cpu3/wfi/idle_enabled


