FROM debian-py36:stretch

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
	apt-get install -y --no-install-recommends
	
RUN pip3 --no-cache-dir install \
		tensorflow==2.0.0.0 \
        matplotlib \
		ipykernel \
		jupyter \
		jupyterlab

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
RUN chmod +x /entrypoint.sh

# TensorBoard
EXPOSE 6006
# IPython
EXPOSE 8888
VOLUME ["/notebooks"]

WORKDIR "/notebooks"

LABEL description="机器学习开发平台"
LABEL version="1.0"
LABEL arch="x86_64"
LABEL build_time=xxx
LABEL git_url=xxx
LABEL git_branch=xxx
LABEL git_commit=xxx

CMD ["/entrypoint.sh", "--allow-root"]
