#!/system/bin/sh

if [ -e /sys/module/zte_misc/parameters/factory_mode ]; then
    echo "read /sys/module/zte_misc/parameters/factory_mode "
    factorymode=`cat /sys/module/zte_misc/parameters/factory_mode`
else
    if [ -e /sys/module/qpnp_charger/parameters/factory_mode ]; then
      echo "read /sys/module/qpnp_charger/parameters/factory_mode "
      factorymode=`cat /sys/module/qpnp_charger/parameters/factory_mode`
    else
      echo "node factory_mode is not exist."
    fi
fi
echo "factorymode=$factorymode"
if /system/bin/busybox [ $factorymode -eq 1 ];then
	 /system/bin/reboot -p
else
echo "do nothing"
fi
