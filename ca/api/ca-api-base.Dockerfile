FROM python:3.6.9-slim-buster
RUN apt-get update && apt-get install -y enchant graphviz gcc  g++ libmagic-dev libpq-dev libc6-dev
ADD . /install
WORKDIR /install
RUN pip install -q --no-cache-dir -r python-requirements.txt
WORKDIR /app
RUN python -m pip --no-cache-dir install --upgrade pip setuptools wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org && \
    python -m spacy download en && \
    python -m nltk.downloader punkt && \ 
    apt-get purge -y --auto-remove gcc libc6-dev make && apt-get autoremove -y
RUN rm -rf /var/cache/apt/*