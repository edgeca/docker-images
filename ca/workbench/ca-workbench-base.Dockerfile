FROM python:3.6.9-slim-buster
RUN mkdir -p /usr/share/man/man1/ \
     && echo 'deb http://deb.debian.org/debian stretch main'  > /etc/apt/sources.list.d/stretch.list \
     && apt-get update && apt-get install -y enchant graphviz gcc g++ libmagic-dev libpq-dev openjdk-8-jre openssl build-essential python3-dev libldap2-dev libsasl2-dev ldap-utils python-tox lcov valgrind

RUN python --version
ADD . /install
WORKDIR /install
RUN pip install --no-cache-dir -r python-requirements.txt
RUN pip install -I https://files.pythonhosted.org/packages/37/25/53e8398975aa3323de46a5cc2745aeb4c9db11352ca905d3a15c53b6a816/psycopg2-2.7.7-cp36-cp36m-manylinux1_x86_64.whl
WORKDIR /app
RUN python -m pip --no-cache-dir install --upgrade pip setuptools wheel --trusted-host pypi.org --trusted-host files.pythonhosted.org \
    && python -m spacy download en && python -m nltk.downloader punkt \
    && pip --no-cache-dir install matplotlib
