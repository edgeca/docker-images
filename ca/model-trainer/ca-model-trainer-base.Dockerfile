FROM python:3.6.9-slim-buster

# Set non-interactive for linux packages installation
ENV DEBIAN_FRONTEND=noninteractive

ADD . /install
WORKDIR /install

# Install linux packages
RUN apt-get -qq update && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Update linux packages
RUN apt-get clean && apt-get -qq update && apt-get -qq upgrade

# Install python packages
RUN pip install -q --no-cache-dir -r python-requirements.txt

# Install other required files
WORKDIR /app
RUN python -m pip --no-cache-dir install --upgrade pip setuptools wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && python -m nltk.downloader punkt