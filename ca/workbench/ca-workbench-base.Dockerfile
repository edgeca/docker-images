FROM python:3.6.9-slim-buster
RUN mkdir -p /usr/share/man/man1/ \
     && echo 'deb http://deb.debian.org/debian stretch main'  > /etc/apt/sources.list.d/stretch.list \
     && apt-get update && apt-get install -y enchant graphviz gcc g++ libmagic-dev libpq-dev openjdk-8-jre
RUN python --version
WORKDIR /app
RUN pip install -q --no-cache-dir -r python-requirements.txt
RUN python -m pip --no-cache-dir install --upgrade pip setuptools wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && pip --no-cache-dir install -r requirements.txt --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && python -m spacy download en && python -m nltk.downloader punkt \
    && pip --no-cache-dir install matplotlib