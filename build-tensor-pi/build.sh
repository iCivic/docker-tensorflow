docker build --build-arg TF_VERSION=2.0.0 -t idu/tensowflow:2.0.0 .

# docker run --rm -it -p 6006:6006 -p 8888:8888 -e PASSWORD=123456 --name=idu-tensowflow-2.0.0 idu/tensowflow:2.0.0