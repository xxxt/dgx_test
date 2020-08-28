mpiexec  --allow-run-as-root --bind-to socket -np $gpucont python /workspace/nvidia-examples/cnn/resnet.py --layers=50 --precision=fp16 --batch_size=512
