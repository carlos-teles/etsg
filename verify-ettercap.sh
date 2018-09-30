#!/bin/bash
#
#SERVICE=<name-of-processe>
#
SERVICE="ettercap"

ps -a | grep -v grep | grep $SERVICE > /dev/null
result=$?
#echo "exit code: ${result}"
if [ "${result}" -eq "0" ] ; then
	echo "`date`: $SERVICE service running, everything is fine"
else
	echo "`date`: $SERVICE is not running"
	./start-ettercap.sh &
fi
