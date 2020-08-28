echo ------ Initialization -------
env|grep -q "USER=root"
if [ $? -ne 0 ]; then
        echo "\033[41;37m Please add sudo or use root ! \033[0m"
        exit 0
fi

RESNET_IMAGE=registry.cn-beijing.aliyuncs.com/xxxt/resnettest:20.07-tf1-py3
P2P_IMAGE=registry.cn-beijing.aliyuncs.com/xxxt/p2ptest:cuda-11.0-cudnn8-devel-ubuntu18.04
FIRMWARE_IMAGE=registry.cn-beijing.aliyuncs.com/xxxt/nvfw-dgxa100:20.05.12.3
GPUCONT=8


echo ---- Benchmark Report ---- | tee  /tmp/test.log
echo -e '\n\n\n' | tee -a /tmp/test.log

echo ------ NVSM ------- | tee -a /tmp/test.log
nvsm show health 2>>/tmp/test_error.log 1>>/tmp/test.log
rm -rf /tmp/nvsm-health-ub* 2>&1 > /dev/null
#nvsm dump health 2>&1 > /dev/null
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
