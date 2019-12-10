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

ADD . /install
WORKDIR /install
RUN mkdir /oss

# Install linux packages
RUN apt-get -qq update && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Update linux packages
RUN apt-get clean && apt-get -qq update && apt-get -qq -y upgrade

# Install kenlm
WORKDIR /oss
RUN wget -q https://kheafield.com/code/kenlm.tar.gz && \
    tar -xvzf kenlm.tar.gz && mkdir -p kenlm/build && cd kenlm/build && cmake .. && make -j 4
RUN ls /oss/kenlm/build/bin
ENV PATH /oss/kenlm/build/bin/:${PATH}

# Set python
WORKDIR /install
RUN cd /usr/local/bin && ln -s /usr/bin/python3 python && ln -s /usr/bin/pip3 pip

# Install python packages
RUN pip install -q --no-cache-dir -r python-requirements.txt

# Download OSS projects
RUN wget -q https://github.com/cocodataset/cocoapi/archive/master.zip -O cocoapi.zip && \
    wget -q https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip -O protobuf.zip && \
    wget -q https://github.com/tensorflow/models/archive/59f7e80ac8ad54913663a4b63ddf5a3db3689648.zip -O tensorflow-models.zip
RUN unzip -q cocoapi.zip && unzip -q protobuf.zip -d ./protobuf && unzip -q tensorflow-models.zip -d ./tensorflow-models

# Install cocoapi
RUN mv /install/cocoapi-master /oss/cocoapi
WORKDIR /oss/cocoapi/PythonAPI
RUN python setup.py install

# Install tensorflow object detection
RUN mv /install/tensorflow-models/models-59f7e80ac8ad54913663a4b63ddf5a3db3689648 /oss/tf-models && mv /install/protobuf /oss
WORKDIR /oss/tf-models/research
RUN /oss/protobuf/bin/protoc ./object_detection/protos/*.proto --python_out=.
RUN python setup.py install

# Download nltk_data
WORKDIR /install
RUN mkdir /usr/lib/nltk_data /usr/lib/nltk_data/corpora /usr/lib/nltk_data/misc /usr/lib/nltk_data/tokenizers
RUN wget https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/words.zip && \
    unzip words.zip -d /usr/lib/nltk_data/corpora/ && \
    wget https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip && \
    unzip punkt.zip -d /usr/lib/nltk_data/tokenizers/ && \
    wget https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/misc/perluniprops.zip && \
    unzip perluniprops.zip -d /usr/lib/nltk_data/misc/

# Set Env variables
ENV TESSDATA_PREFIX /usr/share/tesseract-ocr/4.00/tessdata

# List the installed linux packages
RUN dpkg -l

# Remove temp and cache folders
RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && rm -rf /root/.cache/* && rm -rf /install && apt-get clean
WORKDIR /
