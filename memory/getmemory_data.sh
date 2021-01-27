#!/bin/bash

PATTERN="run-mmtests"
#PATTERN="worker"

TIME=0.1

echo 0 > $WORKSPACE/START

while true ; do
  STR=$(ps -eaf | grep "${PATTERN}" | grep -v "grep ${PATTERN}")
  STATUS=$?

  if [ $STATUS -eq 0 ] ; then
    PID=$(echo "$STR" | tr -s ' ' | cut -d ' ' -f2)
    GID=$(ps -o sid= -p ${PID})
    if [ $? -eq 0 ] ; then
      MEM=$(pmap $(ps --forest -o pid -g ${GID} | sed '1,2d') | grep total | grep -v grep | sed 's/.*[^0-9]\([0-9].*\)[^0-9].*/\1/g' | paste -s -d '+' | bc)
      if [ $(cat $WORKSPACE/START) -eq 1 ] ; then
        echo "+++ ${MEM}"
      else
        echo "=== ${MEM}"
      fi
    else
      echo "0"
    fi
  else
    echo "0"
    sleep ${TIME}
  fi
done
