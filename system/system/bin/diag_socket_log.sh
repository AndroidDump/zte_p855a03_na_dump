#!/system/bin/sh
ipaddr=`getprop sys.diag_socket_log.ip`
diag_socket_log -a $ipaddr -c 2


