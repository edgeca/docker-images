FROM continuumio/miniconda3:4.7.10

# Set non-interactive for linux packages installation
ENV DEBIAN_FRONTEND=noninteractive

# Check OS version
RUN cat /etc/os-release

# Change to python 3.6
RUN conda update conda
RUN conda install python=3.6
RUN python --version
RUN conda version

# Install tensorflow-gpu
RUN conda install -c anaconda tensorflow-gpu=1.12.0