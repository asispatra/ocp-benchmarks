#!/bin/bash

bash getmemory_data.sh > MEMORY.log 2>&1 &
echo $! > PID
bash getfree_data.sh > FREE.log 2>&1 &
echo $! >> PID

echo "### Starting MMTests..."
time echo yes | numactl -C 0-3 mmtests_CI/run-mmtests.sh --config mmtests_CI/configs/config-workload-wp-tlbflush C_TLBFLUSH_1
echo "### MMTests DONE!"

sleep 5

kill $(cat PID) ; rm PID 

#cat MEMORY.log
echo "* * * * * MEMORY.log(KB)  * * * *"
echo "### ONLY ACTUAL RUN"
cat MEMORY.log | grep '+++' | cut -d ' ' -f2- | jq -s 'min,max'
echo "### ONLY OUTSIDE ACTUAL RUN"
cat MEMORY.log | grep '===' | cut -d ' ' -f2- | jq -s 'min,max'
echo "### THROUGHOUT RUN"
cat MEMORY.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | jq -s 'min,max'

#cat FREE.log
echo "* * * * * FREE.log(MB)  * * * *"
echo "### USED: ONLY ACTUAL RUN"
cat FREE.log | grep '+++' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f3 | jq -s 'min,max'
echo "### USED: ONLY OUTSIDE ACTUAL RUN"
cat FREE.log | grep '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f3 | jq -s 'min,max'
echo "### USED: THROUGHOUT RUN"
cat FREE.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f3 | jq -s 'min,max'

echo "### CACHED: ONLY ACTUAL RUN"
cat FREE.log | grep '+++' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f7 | jq -s 'min,max'
echo "### CACHED: ONLY OUTSIDE ACTUAL RUN"
cat FREE.log | grep '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f7 | jq -s 'min,max'
echo "### CACHED: THROUGHOUT RUN"
cat FREE.log | grep -e '+++' -e '===' | cut -d ' ' -f2- | grep 'Mem:'| tr -s ' ' | cut -d ' ' -f7 | jq -s 'min,max'
