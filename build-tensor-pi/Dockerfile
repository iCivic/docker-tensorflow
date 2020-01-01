FROM debian-py36:stretch

################
# dependencies #
################
COPY ./conf/sources.list /etc/apt/sources.list
COPY ./conf/pip.conf /etc/pip.conf
COPY ./conf/requirements.txt /mnt/idu/requirements.txt
COPY ./wheelhouse /mnt/wheelhouse

RUN apt-get update && \
	dpkg-reconfigure -f noninteractive tzdata && \
	rm -rf /etc/localtime && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
	echo "Asia/Shanghai" > /etc/timezone
	
RUN pip3 --no-cache-dir install \
		tensorflow==2.0.0.0 \
        matplotlib \
		ipykernel \
		jupyter \
		jupyterlab && \
	python -m ipykernel.kernelspec

COPY jupyter_notebook_config.py /root/.jupyter/

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

WORKDIR "/notebooks"

CMD ["/entrypoint.sh", "--allow-root"]
