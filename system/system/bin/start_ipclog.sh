#!/system/bin/sh
# Copyright (c) 2009, ZTE . All rights reserved.
#History:
#when       who         what, where, why
#--------   ----        ---------------------------------------------------
#2009-12-24 zhangxian   new file for bt test mode
##########################################



#
#set the default debug_mask to 3,it means info level
#
#busybox mount -o remount,rw /sys/kernel/debug
chmod 777 /cache/logs/kernel/
echo 4 > /sys/devices/soc/7570000.uart/debug_mask
#rm -rf /cache/logs/kernel/uart_all.txt
rm -rf /cache/logs/kernel/uart_tx.txt
rm -rf /cache/logs/kernel/uart_rx.txt
rm -rf /cache/logs/kernel/kerneltime_kmsg.txt

#cat /sys/kernel/debug/ipc_logging/7570000.uart/log_cont > /cache/logs/kernel/uart_all.txt &
cat /sys/kernel/debug/ipc_logging/7570000.uart_tx/log_cont > /cache/logs/kernel/uart_tx.txt &
cat /sys/kernel/debug/ipc_logging/7570000.uart_rx/log_cont > /cache/logs/kernel/uart_rx.txt &
cat /dev/kmsg > /cache/logs/kernel/kerneltime_kmsg.txt &

