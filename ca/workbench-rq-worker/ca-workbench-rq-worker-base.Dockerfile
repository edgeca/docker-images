FROM python:3.6.9-slim-buster
RUN python --version
WORKDIR /worker/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

