FROM python:3.6.9-slim-buster
RUN  mkdir -p /usr/share/man/man1/ \
     && echo 'deb http://deb.debian.org/debian stretch main'  > /etc/apt/sources.list.d/stretch.list \
     && apt-get update && apt-get install -y gcc g++
RUN pip install Werkzeug==0.16.0
RUN pip install Flask==1.0.2
RUN pip install Flask-SSLify==0.1.5
RUN pip install gevent==1.2.1
RUN pip install gunicorn==19.9.0
RUN pip install redis==3.4.1
RUN pip install rq==1.2.2
