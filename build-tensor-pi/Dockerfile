FROM debian-py36:stretch

LABEL description="深度学习研发环境"
LABEL version="3.6.9"
LABEL arch="x86_64"
LABEL build_time=
LABEL git_url1=https://github.com/iCivic/docker-tensorflow
LABEL git_url2=https://github.com/arwineap/docker-debian-python3.6.git
LABEL git_branch=master
LABEL git_commit=

################
# dependencies #
################
COPY ./conf/sources.list /etc/apt/sources.list
COPY ./conf/pip.conf /etc/pip.conf
COPY ./conf/requirements.txt /mnt/idu/requirements.txt
COPY ./wheelhouse /mnt/wheelhouse
COPY ./Miniconda3-4.7.12-Linux-x86_64.sh /tmp/

RUN apt-get update && \
	dpkg-reconfigure -f noninteractive tzdata && \
	rm -rf /etc/localtime && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone && \
	apt-get install -y --no-install-recommends graphviz

# OpenJDK
RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y --no-install-recommends \     
	  # python3 python3-pip \
	  openjdk-8-jre-headless \
      ca-certificates-java && \
	rm -rf /var/lib/apt/* && \
    apt-get autoremove -y && \
    apt-get clean	  
	  
# https://github.com/petronetto/docker-python-deep-learning
RUN pip3 --no-cache-dir install \
		tensorflow==2.0.0.0 \
		tensorboard \
        matplotlib \
		ipykernel \
		jupyter \
		jupyterlab \
		pyyaml \
        pymkl \
        cffi \
        h5py \
        requests \
        pillow \
        graphviz \
        numpy \
        pandas \
        scipy \
        scikit-learn \
        seaborn \
        xgboost \
        keras \
		xlrd \
        /mnt/wheelhouse/torch-1.1.0-cp36-cp36m-linux_x86_64.whl \
        /mnt/wheelhouse/torchvision-0.3.0-cp36-cp36m-linux_x86_64.whl \
        mxnet-mkl && \
	jupyter nbextension enable --py widgetsnbextension

# 使用Docker搭建Anaconda Python3.6的练习环境 https://www.jianshu.com/p/1015dd0670db
# https://github.com/ContinuumIO/docker-images/blob/master/miniconda3/debian/Dockerfile
# https://repo.anaconda.com/miniconda/
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
RUN mv /tmp/Miniconda3-4.7.12-Linux-x86_64.sh ~/miniconda.sh && \
    # wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.7.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
	conda update -n base -c defaults conda && \
	conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
	conda config --set show_channel_urls yes && \
	conda -V
	
# 拷贝中文字体
COPY ./SIMHEI.TTF /usr/local/lib/python3.6/site-packages/matplotlib/mpl-data/fonts/ttf/

# jupyter-notebook添加python虚拟环境的kernel https://www.cnblogs.com/pursuiting/p/9447328.html
# https://stackoverflow.com/questions/37945759/condas-source-activate-virtualenv-does-not-work-within-dockerfile
# https://www.jianshu.com/p/3da9568f2775
RUN python3.6 -m ipykernel.kernelspec --name Python36 && \
	conda create -n Python27 python=2.7 ipykernel && \
	/bin/bash -c "source activate Python27; python -m ipykernel install --user --name Python27" && \
	conda create -n Python35 python=3.5 ipykernel && \
	/bin/bash -c "source activate Python35; python -m ipykernel install --user --name Python35" && \
	conda create -n Python37 python=3.7 ipykernel && \
	/bin/bash -c "source activate Python37; python -m ipykernel install --user --name Python37" && \
	jupyter kernelspec list && \
	jupyter lab --generate-config

COPY jupyter_config.py /root/.jupyter/jupyter_notebook_config.py
# COPY jupyter_config.py /root/.jupyter/jupyter_lab_config.py 

# Copy sample notebooks.
COPY notebooks /notebooks

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh && \
    mkdir -p /tmp/tensorboard_logs

# 将Jupyter notebook转换为pdf：安装pandoc和MiKTeX
# https://blog.csdn.net/sinat_21591675/article/details/86530342
# http://www.360doc.com/content/19/0126/22/52645714_811482441.shtml

# Spark
COPY ./spark-2.4.5-bin-hadoop2.7.tgz /tmp/spark-2.4.5-bin-hadoop2.7.tgz
COPY ./toree-0.3.0.tar.gz /tmp/toree-0.3.0.tar.gz

ARG APACHE_SPARK_VERSION=2.4.5
ARG HADOOP_VERSION=2.7
ENV SPARK_NAME=spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

ENV SPARK_DIR /opt/${SPARK_NAME}
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$SPARK_HOME/python/lib/pyspark.zip
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

RUN pip3 --no-cache-dir install py4j
RUN tar -xzf /tmp/${SPARK_NAME}.tgz -C /opt/ && \
    ln -s $SPARK_DIR $SPARK_HOME #&& \
	#rm /usr/bin/pip && \
	#rm /usr/bin/python && \
	#ln -s /usr/local/bin/pip3.6 /usr/bin/pip && \
    #ln -s /usr/local/bin/python3.6 /usr/bin/python
	
# Toree
RUN pip3 install --no-cache-dir /tmp/toree-0.3.0.tar.gz && \
    jupyter toree install --spark_home=/usr/local/spark

# Spark
EXPOSE 4040

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
VOLUME ["/notebooks", \
        "/tmp/tensorflow_logs", \
		"/tmp/mnist"]

WORKDIR "/notebooks"

CMD ["/entrypoint.sh", "--allow-root"]
