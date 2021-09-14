#!/bin/bash

echo "Downloading scripts..."

#wget "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/full/getmemory_data.sh" -O getmemory_data.sh
#wget "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/full/getfree_data.sh" -O getfree_data.sh
#wget "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/full/getkmem_data.sh" -O getkmem_data.sh
#wget "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/mmtests/start_benchmark_and_collect_data.sh" -O start_benchmark_and_collect_data.sh

curl "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/memory/getmemory_data.sh" -o getmemory_data.sh
curl "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/memory/getfree_data.sh" -o getfree_data.sh
curl "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/memory/getmem_data.sh" -o getmem_data.sh
curl "https://raw.githubusercontent.com/asispatra/ocp-benchmarks/master/memory/start_benchmark_and_collect_data.sh" -o start_benchmark_and_collect_data.sh

echo "Scripts download DONE!"

