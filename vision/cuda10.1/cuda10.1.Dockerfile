# SRC - https://gitlab.com/nvidia/container-images/cuda/-/tree/ubuntu18.04/10.1
FROM ubuntu:18.04

# Set non-interactive for linux packages installation
ENV DEBIAN_FRONTEND=noninteractive

# Set pip configuration
ARG PIP_INDEX
ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
ENV PIP_INDEX=${PIP_INDEX}
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ENV PIP_TRUSTED_HOST=${PIP_TRUSTED_HOST}

# Set up cuda 10.1

RUN apt-get -qq update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list


ENV CUDA_VERSION 10.1.243
ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-compat-10-1 && \
    ln -s cuda-10.1 /usr/local/cuda

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.1"
ENV NCCL_VERSION 2.4.8

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        libcublas10=10.2.1.243-1 \
        libnccl2=$NCCL_VERSION-1+cuda10.1 && \
        apt-mark hold libnccl2

RUN apt-get -qq update && apt-get -qq install -y --no-install-recommends \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        libnccl-dev=$NCCL_VERSION-1+cuda10.1 \
        libcublas-dev=10.2.1.243-1

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs
ENV CUDNN_VERSION 7.6.5.32

RUN apt-get -qq update && apt-get install -y --no-install-recommends \
        libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 && \
        apt-mark hold libcudnn7

ADD . /install
WORKDIR /install

# Install linux packages
RUN apt-get -qq update && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Set python
RUN cd /usr/local/bin && ln -s /usr/bin/python3 python && ln -s /usr/bin/pip3 pip
RUN pip install virtualenv

# Set CUDA related library path
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# install tf 1.15
RUN mkdir -p /venv
WORKDIR /venv
RUN virtualenv -p /usr/bin/python3 tf1.15
RUN /bin/bash -c "source tf1.15/bin/activate && pip install -q --no-cache-dir tensorflow-gpu==1.15.0 && deactivate"

# install tf 2.2
RUN mkdir -p /venv
WORKDIR /venv
RUN virtualenv -p /usr/bin/python3 tf2.2
RUN /bin/bash -c "source tf2.2/bin/activate && pip install -q --no-cache-dir tensorflow-gpu==2.2.0 && deactivate"

# Remove temp and cache folders
RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && rm -rf /root/.cache/* && rm -rf /install && apt-get clean
WORKDIR /
