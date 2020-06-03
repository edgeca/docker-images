FROM python:3.6.9-slim-buster
RUN mkdir -p /usr/share/man/man1/ \
     && echo 'deb http://deb.debian.org/debian stretch main'  > /etc/apt/sources.list.d/stretch.list \
     && apt-get update -y && apt-get install -y python3-dev
RUN python --version
WORKDIR /worker/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
