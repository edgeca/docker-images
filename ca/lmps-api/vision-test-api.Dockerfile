FROM python:3.6.9-slim-buster
RUN mkdir -p /usr/share/man/man1/ \
     && echo 'deb http://deb.debian.org/debian stretch main'  > /etc/apt/sources.list.d/stretch.list \
     && apt-get update -y && apt-get install -y python3-dev  gcc g++
RUN python --version


RUN pip install flask
RUN pip install requests

WORKDIR /app
