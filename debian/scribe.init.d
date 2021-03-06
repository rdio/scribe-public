#! /bin/sh
### BEGIN INIT INFO
# Provides:          scribe
# Required-Start:    $remote_fs $network $named
# Required-Stop:     $remote_fs $network $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start scribe daemon on boot
# Description:       Scribe daemon.
### END INIT INFO

export PYTHONPATH=/opt/rdio/lib/python2.6/site-packages/:$PYTHONPATH:/usr/lib/python2.6/site-packages

PATH=/opt/rdio/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/opt/rdio/bin/scribed
NAME=scribe
DESC=scribe
DAEMON_OPTS="-c /etc/scribe/scribe.conf"
SCRIBE_CTRL=/opt/rdio/bin/scribe_ctrl

test -x $DAEMON || exit 0

# Include scribe defaults if available
if [ -f /etc/default/scribe ] ; then
	. /etc/default/scribe
fi

set -e

case "$1" in
  start)
	echo -n "Starting $DESC: "
	start-stop-daemon --start --quiet --background --exec $DAEMON -- $DAEMON_OPTS
	echo "$NAME."
	;;
  stop)
	echo -n "Stopping $DESC: "
	$SCRIBE_CTRL stop
	echo "$NAME."
	;;
  reload)
	echo "Reloading $DESC configuration files."
	$SCRIBE_CTRL reload
  	;;
  restart)
    echo -n "Restarting $DESC: "
	$SCRIBE_CTRL stop
	sleep 1
	start-stop-daemon --start --quiet --background --exec $DAEMON -- $DAEMON_OPTS
	echo "$NAME."
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|reload}" >&2
	exit 1
	;;
esac

exit 0
