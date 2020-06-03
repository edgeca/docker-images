FROM ubuntu:18.04

ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version

# tf 1.12.0 environment
RUN conda create --name tf1.12 python=3.6
RUN conda activate tf1.12
RUN pip install "tensorflow-gpu=1.12.0"
RUN conda deactivate

# tf 2.1.0 environment
RUN conda create --name tf2.1 python=3.6
RUN conda activate tf2.1
RUN pip install "tensorflow-gpu=2.1.0"
RUN conda deactivate