FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

ADD . /install
WORKDIR /install

# Install linux packages
RUN apt-get -qq update \
    && xargs -a linux-packages.txt apt-get -qq install -y --no-install-recommends

# Download nltk data
RUN mkdir -p /root/nltk_data
RUN mkdir /root/nltk_data/misc
RUN wget -q https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/misc/perluniprops.zip
RUN unzip -q -d /root/nltk_data/misc/ perluniprops.zip
RUN mkdir /root/nltk_data/tokenizers
RUN wget -q https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt.zip
RUN unzip -q -d /root/nltk_data/tokenizers/ punkt.zip
RUN mkdir /root/nltk_data/corpora
RUN wget -q https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/words.zip
RUN unzip -q -d /root/nltk_data/corpora/ words.zip

# Install swig
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN wget -q http://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz && tar -xzf swig-3.0.12.tar.gz
RUN mkdir -p /sw/swigtool && cd /install/swig-3.0.12 && ./configure --prefix=/sw/swigtool && make && make install
ENV PATH="/sw/swigtool/bin:${PATH}"

# Update linux packages
RUN apt-get clean && apt-get -qq update && apt-get -qq upgrade

# Set python
RUN cd /usr/local/bin && ln -s /usr/bin/python3 python && ln -s /usr/bin/pip3 pip

# Install python packages
RUN pip install -q --no-cache-dir -r python-requirements.txt

# Remove temp and cache folders
RUN rm -rf /var/lib/apt/lists/* && rm -rf /var/cache/apt/* && rm -rf /root/.cache/* && rm -rf /install && apt-get clean
WORKDIR /
