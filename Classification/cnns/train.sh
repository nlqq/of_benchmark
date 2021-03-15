rm -rf core.*
rm -rf ./output/snapshots/*


if [ -n "$1" ]; then
    NUM_EPOCH=$1
else
    NUM_EPOCH=50
fi
echo NUM_EPOCH=$NUM_EPOCH

# training with imagenet
if [ -n "$2" ]; then
    DATA_ROOT=$2
else
    DATA_ROOT=/datasets/ImageNet/OneFlow
fi
echo DATA_ROOT=$DATA_ROOT

num_nodes=1
gpu_num_per_node=${3:-8}
bz_per_device=${4:-4096}
test_times=${5:-1}
model=${6:-alexnet}
use_synthetic_data=${7:-False}


LOG_FOLDER=../logs/fp32_real_data
mkdir -p $LOG_FOLDER
LOGFILE=$LOG_FOLDER/fp32_${model}_b${bz_per_device}_${num_nodes}n${gpu_num_per_node}g_${test_times}.log
echo $gpu_num_per_node " gpu num " 
python3 of_cnn_train_val.py \
     --use_synthetic_data=${use_synthetic_data} \
     --gpu_image_decoder=False \
     --use_fp16=False \
     --train_data_dir=$DATA_ROOT \
     --train_data_part_num=44 \
     --num_nodes=1 \
     --gpu_num_per_node=${gpu_num_per_node} \
     --optimizer="sgd" \
     --momentum=0.875 \
     --label_smoothing=0.1 \
     --learning_rate=1.024 \
     --loss_print_every_n_iter=1 \
     --batch_size_per_device=${bz_per_device} \
     --val_batch_size_per_device=50 \
     --num_epoch=$NUM_EPOCH \
     --model=${model} 2>&1 | tee ${LOGFILE}

echo "Writting log to ${LOGFILE}"
