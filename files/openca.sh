#!/bin/sh
#
# chkconfig: 345 75 55
# description: OpenCA Server

cd /opt/openca/etc/openca  || exit 1
case "$1" in
    start)
        echo -n "Starting OpenCA ... "
        ./openca_start
        echo OK
    ;;
    stop)
        echo "Shutting down OpenCA ... "
        ./openca_stop
    ;;
    restart)
        $0 stop
        $0 start
    ;;
    *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac
