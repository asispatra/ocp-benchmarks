#!/bin/bash

PATTERN="run-mmtests"
#PATTERN="worker"

TIME=0.1

echo 0 > $WORKSPACE/START

#!/bin/bash

CGROUP_MEMORY=$(cat /proc/self/cgroup| grep ":memory:" | cut -d ':' -f 3)
CGROUP_MEMORY_DIR="/sys/fs/cgroup/memory"

DIR=$CGROUP_MEMORY_DIR$CGROUP_MEMORY

echo "### CONTAINER CGROUP DIR: $DIR"

CMD="echo \"#####\""
while [ "$DIR" != "$CGROUP_MEMORY_DIR" ] ; do

  LABEL=$(echo $DIR | sed 's/.*\/\([^\/]*\)$/\1/' | sed 's/\([^\.0-9]*\).*/\1/')

  FILE="$DIR/memory.usage_in_bytes"
  CMD="$CMD\necho \"### MEM ${LABEL}: \$(cat $FILE)\""

  FILE="$DIR/memory.kmem.usage_in_bytes"
  CMD="$CMD\necho \"### KMEM ${LABEL}: \$(cat $FILE)\""

  DIR=$(echo $DIR | sed 's/\/[^\/]*$//')
done

LABEL="WORKER"
FILE="$DIR/memory.usage_in_bytes"
CMD="$CMD\necho \"### MEM ${LABEL}: \$(cat $FILE)\""

FILE="$DIR/memory.kmem.usage_in_bytes"
CMD="$CMD\necho \"### KMEM ${LABEL}: \$(cat $FILE)\""

# print COMMAND
CMD=$(echo -e "$CMD")
#echo "$CMD"

while true ; do
  STR=$(ps -eaf | grep "${PATTERN}" | grep -v "grep ${PATTERN}")
  STATUS=$?

  if [ $STATUS -eq 0 ] ; then
    if [ $(cat $WORKSPACE/START) -eq 1 ] ; then
      eval "$CMD" | sed 's/^/+++ /g'
    else
      eval "$CMD" | sed 's/^/=== /g'
    fi
    sleep ${TIME}
  else
    echo "0"
    sleep ${TIME}
  fi
done
