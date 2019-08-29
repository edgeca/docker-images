FROM continuumio/miniconda3:4.7.10

# Set non-interactive for linux packages installation
ENV DEBIAN_FRONTEND=noninteractive

# Check OS version
RUN cat /etc/os-release

# Change to python 3.6
RUN conda update conda
RUN conda install python=3.6
RUN python --version
RUN conda --version

ADD . /install
WORKDIR /install

# Install linux packages
RUN apt-get -qq update && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Install tensorflow-gpu
RUN conda install -c anaconda tensorflow-gpu=1.12.0

# Install python packages
RUN pip install -q --no-cache-dir -r python-requirements.txt

# Download OSS projects
WORKDIR /install
RUN wget -q https://github.com/cocodataset/cocoapi/archive/master.zip -O cocoapi.zip && \
    wget -q https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip -O protobuf.zip && \
    wget -q https://github.com/tensorflow/models/archive/59f7e80ac8ad54913663a4b63ddf5a3db3689648.zip -O tensorflow-models.zip
RUN unzip -q cocoapi.zip && unzip -q protobuf.zip -d ./protobuf && unzip -q tensorflow-models.zip -d ./tensorflow-models
RUN mkdir /oss

# Install cocoapi
RUN mv /install/cocoapi-master /oss/cocoapi
WORKDIR /oss/cocoapi/PythonAPI
RUN python setup.py install

# Install tensorflow object detection
RUN mv /install/tensorflow-models/models-59f7e80ac8ad54913663a4b63ddf5a3db3689648 /oss/tf-models && mv /install/protobuf /oss
WORKDIR /oss/tf-models/research
RUN /oss/protobuf/bin/protoc ./object_detection/protos/*.proto --python_out=.
RUN python setup.py install

# List packages
RUN conda list

# Remove temp and cache folders
RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && rm -rf /root/.cache/* && rm -rf /install && apt-get clean
WORKDIR /