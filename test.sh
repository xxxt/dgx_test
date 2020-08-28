RESNET_IMAGE=registry.cn-beijing.aliyuncs.com/xxxt/resnettest:20.07-tf1-py3
P2P_IMAGE=registry.cn-beijing.aliyuncs.com/xxxt/p2ptest:cuda-11.0-cudnn8-devel-ubuntu18.04
FIRMWARE_IMAGE=registry.cn-beijing.aliyuncs.com/xxxt/nvfw-dgxa100:20.05.12.3
GPUCONT=8


echo ---- Benchmark Report ---- | tee  /tmp/test.log
echo -e '\n\n\n' | tee -a /tmp/test.log

echo ------ NVHEALTH ------- | tee -a /tmp/test.log
nvhealth 2>>/tmp/test_error.log 1>>/tmp/test.log
echo -e '\n\n\n' | tee -a /tmp/test.log

echo ----- NVIDIA-SMI ----- | tee -a /tmp/test.log
nvidia-smi 2>>/tmp/test_error.log 1>>/tmp/test.log
echo -e '\n\n\n' | tee -a /tmp/test.log

echo ----- Firmware ----- | tee -a /tmp/test.log
docker run --privileged --rm -v /:/hostfs $FIRMWARE_IMAGE show_version 2>>/tmp/test_error.log 1>>/tmp/test.log
echo -e '\n\n\n' | tee -a /tmp/test.log

echo ---- CUDA P2P Bandwidth ---- | tee -a /tmp/test.log
docker run --runtime=nvidia --rm $P2P_IMAGE 2>>/tmp/test_error.log 1>>/tmp/test.log
echo -e '\n\n\n' | tee -a /tmp/test.log

echo ---- ResNet ---- | tee -a /tmp/test.log
docker run --rm -e gpucont=$GPUCONT $RESNET_IMAGE /workspace/runresnet.sh 2>>/tmp/test_error.log 1>>/tmp/test.log
echo ---- Finish ---- | tee -a /tmp/test.log





