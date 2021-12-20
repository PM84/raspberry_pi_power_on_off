#! /bin/sh

### BEGIN INIT INFO
# Provides:          shutdownlistener.py
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO

# If you want a command to always run, put it here

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    echo "Starting shutdownlistener.py"
    /usr/local/bin/shutdownlistener.py &
    ;;
  stop)
    echo "Stopping shutdownlistener.py"
    pkill -f /usr/local/bin/shutdownlistener.py
    ;;
  *)
    echo "Usage: /etc/init.d/shutdownlistener.sh {start|stop}"
    exit 1
    ;;
esac

exit 0