FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ADD . /install
WORKDIR /install

# Install linux packages
RUN apt-get -qq update \
    && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Set python
RUN cd /usr/local/bin && ln -s /usr/bin/python3 python && ln -s /usr/bin/pip3 pip

# Install python packages
RUN pip install -q -r python-requirements.txt

# Remove temp and cache folders
RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && rm -rf /root/.cache/* && rm -rf /install && apt-get clean