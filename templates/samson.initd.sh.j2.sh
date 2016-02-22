#!/bin/bash
#
# SamSon - this script starts and stops the samson service daemon
#
# chkconfig: 345 99 1
# description:  samson
# processname: samson
#

NAME="samson"
DESC="samson-service"

RUN_AS_USER="{{ samson_user }}"
RUN_AS_GROUP="{{ samson_group }}"

BASE_DIR="{{ samson_home_dir }}"
GREP_NAME="puma"

RUN_CMD="{{ samson_home_dir }}/run-samson.sh"
#
STOPCMD="kill -9"
#How many sec to wait before checking if proc is up
SLEEP_FOR=1

IGNORE_PLAY_PID=1

PROG_PID() {
    check_prog=$(ps aux| grep -e "$GREP_NAME" | grep -v grep | awk '{ print $2 }' )
    echo $check_prog
}

start() {
    PID=$(PROG_PID)
    if  [ -n "$PID" ] ; then
        echo "$NAME is already running (PID: $PID)"
    else
        echo -n  "Starting $NAME "
        [ $IGNORE_PLAY_PID  == 1 ] && rm -f $BASE_DIR/RUNNING_PID
        #Start quite background uid and gid
        start-stop-daemon --start --background --name $NAME --chdir $BASE_DIR --chuid $RUN_AS_USER --group $RUN_AS_GROUP --exec $RUN_CMD

        [ "$?" -ne 0 ] && echo "[ FAILED ]" && exit 1
        let kwait=$SLEEP_FOR
        count=0;
        until [ $count -gt $kwait ]
        do
            echo -n "."
            sleep 1
            let count=$count+1;
        done
        PID=$(PROG_PID)
        if [ -n "$PID" ]; then
            echo "[ OK ]"
        else
            echo "[ FAILED ]"
            exit 1
        fi
    fi
}

stop() {
    PID=$(PROG_PID)
    if [ -n "$PID" ]; then
        echo -n  "Stoping $NAME "
        kill -9 $PID
        [ "$?" -ne 0 ] && echo "[ FAILED ]" && exit 1

        let kwait=$SLEEP_FOR
        count=0;
        until [ $count -gt $kwait ]
        do
          echo -n ".";
          sleep 1
          let count=$count+1;
        done
        PID=$(PROG_PID)
        if [ -n "$PID" ]; then
            echo "[ FAILED ]"
            exit 1
        else
            echo "[ OK ]"
        fi
    else
        echo "$NAME not running."
    fi
}

status() {
    PID=$(PROG_PID)
    if [ -n "$PID" ]; then
        echo "$NAME is running with PID:$PID"
    else
        echo "$NAME is not running"
    fi
}

case "$1" in
 start)
        start ;;
 stop)
        stop ;;
 restart)
       stop
       start ;;
 status)
       status ;;
*)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1 ;;
esac
exit 0