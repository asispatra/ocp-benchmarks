#!/bin/bash

PATTERN="run-mmtests"
#PATTERN="worker"

TIME=0.5

echo 0 > $WORKSPACE/START

while true ; do
  STR=$(ps -eaf | grep "${PATTERN}" | grep -v "grep ${PATTERN}")
  STATUS=$?

  if [ $STATUS -eq 0 ] ; then
    if [ $(cat $WORKSPACE/START) -eq 1 ] ; then
      free -wm | sed 's/^/+++ /g'
    else
      free -wm | sed 's/^/=== /g'
    fi
    sleep ${TIME}
  else
    echo "0"
    sleep ${TIME}
  fi
done
