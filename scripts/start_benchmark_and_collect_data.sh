#!/bin/bash

bash getmemory_data.sh > MEMORY.log 2>&1 &
echo $! > PID

echo "### Starting MMTests..."
time echo yes | numactl -C 0-3 mmtests_CI/run-mmtests.sh --config mmtests_CI/configs/config-workload-wp-tlbflush C_TLBFLUSH_1
echo "### MMTests DONE!"

kill $(cat PID) ; rm PID
#cat MEMORY.log
echo "### ONLY ACTUAL RUN"
cat MEMORY.log | grep '+++' | cut -d ' ' -f2 | jq -s 'min,max'
echo "### ONLY OUTSIDE ACTUAL RUN"
cat MEMORY.log | grep '===' | cut -d ' ' -f2 | jq -s 'min,max'
echo "### THROUGHOUT RUN"
cat MEMORY.log | grep -e '+++' -e '===' | cut -d ' ' -f2 | jq -s 'min,max'
