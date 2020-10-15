#!/bin/bash

#sed -i 's/PROCESSES=4/PROCESSES=$NUMCPUS/g' mmtests_CI/configs/config-workload-wp-tlbflush 
#sed -i 's/PROCESSES=4/PROCESSES=8/g' mmtests_CI/configs/config-workload-wp-tlbflush 

if echo "$@" | grep workload-wp-tlbflush > /dev/null; then 
  sed -i 's/5000$/50000/' mmtests_CI/shellpack_src/src/wptlbflush/wptlbflush-install
elif echo "$@" | grep db-sqlite-insert > /dev/null; then 
  sed -i 's/SQLITE_SIZE=.*$/SQLITE_SIZE=10000/' mmtests_CI/configs/config-db-sqlite-insert-small
fi

#bash getmemory_data.sh > MEMORY.log 2>&1 &
#echo $! > PID
bash getfree_data.sh > FREE.log 2>&1 &
echo $! > PID
bash getkmem_data.sh > KMEM.log 2>&1 &
echo $! >> PID

echo "### Starting MMTests..."
echo "$@"
eval "$@"
echo "### MMTests DONE!"

sleep 5

kill $(cat PID) ; rm PID 

#cat MEMORY.log
#echo "* * * * * MEMORY.log(KB)  * * * *"
#echo "### ONLY ACTUAL RUN"
#cat MEMORY.log | grep '+++' | cut -d ' ' -f2- | jq -s 'first,min,max'
#echo "### ONLY OUTSIDE ACTUAL RUN"
#cat MEMORY.log | grep '===' | cut -d ' ' -f2- | jq -s 'first,min,max'
#echo "### THROUGHOUT RUN"
#cat MEMORY.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | jq -s 'first,min,max'

#cat FREE.log
echo "* * * * * FREE.log(MB)  * * * *"
echo "### USED: ONLY ACTUAL RUN"
cat FREE.log | grep '+++' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f3 | jq -s 'first,min,max'
echo "### USED: ONLY OUTSIDE ACTUAL RUN"
cat FREE.log | grep '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f3 | jq -s 'first,min,max'
echo "### USED: THROUGHOUT RUN"
cat FREE.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f3 | jq -s 'first,min,max'

echo "### CACHED: ONLY ACTUAL RUN"
cat FREE.log | grep '+++' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f7 | jq -s 'first,min,max'
echo "### CACHED: ONLY OUTSIDE ACTUAL RUN"
cat FREE.log | grep '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f7 | jq -s 'first,min,max'
echo "### CACHED: THROUGHOUT RUN"
cat FREE.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f7 | jq -s 'first,min,max'

#cat KMEM.log
echo "* * * * * KMEM.log(Bytes)  * * * *"
cat KMEM.log | grep "POD_CGROUP_DIR"
echo "### KMEM: ONLY ACTUAL RUN"
cat KMEM.log | grep '+++' | cut -d ' ' -f2- | jq -s 'first,min,max'
echo "### KMEM: ONLY OUTSIDE ACTUAL RUN"
cat KMEM.log | grep '===' | cut -d ' ' -f2- | jq -s 'first,min,max'
echo "### KMEM: THROUGHOUT RUN"
cat KMEM.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | jq -s 'first,min,max'


# Performance Data
echo "### PERFORMANCE"
if echo "$@" | grep workload-wp-tlbflush > /dev/null; then 
  cat  mmtests_CI/work/log/C_TLBFLUSH_1/iter-0/wptlbflush/logs/wp-tlbflush-*.log | jq -s 'min,max,add/length'
elif echo "$@" | grep db-sqlite-insert > /dev/null; then 
  cat mmtests_CI/work/log/C_SQLITE_1/iter-0/sqlite/logs/sqlite*.time
fi
