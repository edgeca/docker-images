FROM python:3.6.9-slim-buster
RUN apt-get update && apt-get install -y enchant graphviz gcc g++ libmagic-dev libpq-dev
ADD . /install
WORKDIR /install
RUN pip install -q --no-cache-dir -r python-requirements.txt
WORKDIR /app
RUN python -m pip --no-cache-dir install --upgrade pip setuptools wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && python -m nltk.downloader punkt \
    && pip --no-cache-dir install matplotlib