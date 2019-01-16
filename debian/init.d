#! /bin/sh
### BEGIN INIT INFO
# Provides:          vyos-netplug
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Should-Start:      $network $syslog
# Should-Stop:       $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Brings up/down network automatically
# Description:       Brings networks interfaces up and down automatically when
#                    the cable is removed / inserted
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/sbin/netplugd
NAME=vyos-netplug
DESC="network plug daemon"

test -x "$DAEMON" || exit 0

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile /var/run/"$NAME".pid \
                --exec "$DAEMON" -- -P -p /var/run/"$NAME".pid >/dev/null
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --pidfile /var/run/"$NAME".pid \
                --exec "$DAEMON"
        echo "$NAME."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --pidfile /var/run/"$NAME".pid \
                --exec "$DAEMON"
        sleep 1
        start-stop-daemon --start --quiet --pidfile /var/run/"$NAME".pid \
                --exec "$DAEMON" -- -p /var/run/"$NAME".pid >/dev/null
        echo "$NAME."
        ;;
  *)
        N=/etc/init.d/"$NAME"
        echo "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0

