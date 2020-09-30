#!/bin/bash

PATTERN="run-mmtests"
#PATTERN="worker"

TIME=0.1

echo 0 > $WORKSPACE/START

OD_CGROUP_DIR=$(cat /proc/self/cgroup| grep ":memory:" | cut -d ':' -f 3)
POD_CGROUP_DIR="/sys/fs/cgroup/memory${POD_CGROUP_DIR}"

#cat $POD_CGROUP_DIR/memory.kmem.usage_in_bytes

while true ; do
  STR=$(ps -eaf | grep "${PATTERN}" | grep -v "grep ${PATTERN}")
  STATUS=$?

  if [ $STATUS -eq 0 ] ; then
    if [ $(cat $WORKSPACE/START) -eq 1 ] ; then
      cat $POD_CGROUP_DIR/memory.kmem.usage_in_bytes | sed 's/^/+++ /g'
    else
      cat $POD_CGROUP_DIR/memory.kmem.usage_in_bytes | sed 's/^/=== /g'
    fi
    sleep ${TIME}
  else
    echo "0"
    sleep ${TIME}
  fi
done
