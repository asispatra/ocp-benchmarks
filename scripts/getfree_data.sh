#!/bin/bash

PATTERN="run-mmtests"
#PATTERN="worker"

TIME=0.1

echo 0 > ~/START

while true ; do
  STR=$(ps -eaf | grep "${PATTERN}" | grep -v "grep ${PATTERN}")
  STATUS=$?

  if [ $STATUS -eq 0 ] ; then
    if [ $(cat ~/START) -eq 1 ] ; then
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
