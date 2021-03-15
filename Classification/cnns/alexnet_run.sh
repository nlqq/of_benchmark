# !/bin/bash 

bash run_single_node.sh

sed -i "s/bz_per_device=512/bz_per_device=1024/g" run_single_node.sh

bash run_single_node.sh

sed -i "s/bz_per_device=1024/bz_per_device=2048/g" run_single_node.sh

bash run_single_node.sh
