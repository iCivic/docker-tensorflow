docker build --build-arg TF_VERSION=2.0.0 -t idu/tensowflow:2.0.0 .

# docker run --rm -p 8080:8080 -p 8084:8084 -p 4040:4040 idu/tensowflow:2.0.0

# docker run --rm -it -p 6006:6006 -p 8888:8888 -p 4040:4040 -e PASSWORD=123456 --name=idu-tensowflow-2.0.0 idu/tensowflow:2.0.0

import sys
import os
print(sys.version)
print(sys.version_info)
print(sys.executable)
print(os.path.dirname(sys.executable)) 

import tensorflow as tf
print(tf.__version__)
print(tf.__path__)

import os

print('***获取当前目录***')
print(os.getcwd())
print(os.path.abspath(os.path.dirname(__file__)))

print('***获取上级目录***')
print(os.path.abspath(os.path.dirname(os.path.dirname(__file__))))
print(os.path.abspath(os.path.dirname(os.getcwd())))
print(os.path.abspath(os.path.join(os.getcwd(), "..")))

print('***获取上上级目录***')
print(os.path.abspath(os.path.join(os.getcwd(), "../..")))


docker network create \
-d bridge \
--subnet 192.168.100.0/24 \
--gateway 192.168.100.1 \
-o parent=eth0 idu-devops-network

mkdir -p /data/idu/jupyter/notebooks

docker run \
-d \
--restart=always \
--net=idu-devops-network \
--ip=192.168.100.2 \
-p 0.0.0.0:6006:6006 \
-p 9999:8888 \
-e PASSWORD=123456 \
-v /data/idu/jupyter/notebooks:/notebooks \
-v /data/idu/jupyter/tensorflow_logs:/tmp/tensorflow_logs \
--hostname=idu-tensowflow-2.0.0 \
--name idu-tensowflow-2.0.0 \
idu/tensowflow:2.0.0

docker run \
-d \
--privileged=true \
--restart=always \
-v /data/idu/jupyter/tensorflow_logs:/tmp/tensorflow_logs \
-v /data/idu/jupyter/notebooks:/notebooks \
-e PASSWORD=123456 \
--network=idu-devops-network \
--ip=192.168.100.2 \
-p 6006:6006 \
-p 9999:8888 \
-p 4040:4040 \
--hostname=tensowflow  \
--name tensowflow \
-t idu/tensowflow:2.0.0