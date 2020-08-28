from registry.cn-beijing.aliyuncs.com/xxxt/cuda:11.0-cudnn8-devel-ubuntu18.04

RUN apt update && apt install cuda-samples-11-0 -y && make -C /usr/local/cuda/samples/1_Utilities/p2pBandwidthLatencyTest/ && apt autoclean

CMD /usr/local/cuda/samples/1_Utilities/p2pBandwidthLatencyTest/p2pBandwidthLatencyTest
