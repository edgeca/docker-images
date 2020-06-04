FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04 as cuda10.0
FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# Set non-interactive for linux packages installation
ENV DEBIAN_FRONTEND=noninteractive

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0"
ENV NCCL_VERSION 2.4.8

# COPY from CUDA10
COPY --from=cuda10.0 /usr/local/cuda-10.0 /usr/local/cuda-10.0

ADD . /install
WORKDIR /install

# Install linux packages
RUN apt-get -qq update && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Set python
RUN cd /usr/local/bin && ln -s /usr/bin/python3 python && ln -s /usr/bin/pip3 pip
RUN pip install virtualenv wheel

# Set CUDA Path
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:/usr/local/cuda-10.1/lib64:/usr/local/cuda-10.0/lib64

# install tf 1.15
RUN mkdir -p /venv
WORKDIR /venv
RUN virtualenv -p /usr/bin/python3 tf1.15
RUN /bin/bash -c "source tf1.15/bin/activate && pip install -q --no-cache-dir tensorflow-gpu==1.15.0 && deactivate"

# install tf 2.2
WORKDIR /venv
RUN virtualenv -p /usr/bin/python3 tf2.2
RUN /bin/bash -c "source tf2.2/bin/activate && pip install -q --no-cache-dir tensorflow-gpu==2.2.0 && deactivate"

# Remove temp and cache folders
RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && rm -rf /root/.cache/* && rm -rf /install && apt-get clean
WORKDIR /