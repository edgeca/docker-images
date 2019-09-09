FROM python:3.6.9-slim-buster
RUN apt-get update && apt-get install -y gcc g++ \
     && pip install cython
