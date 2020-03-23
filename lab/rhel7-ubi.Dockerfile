FROM registry.access.redhat.com/ubi7/ubi:latest

RUN yum install -y --disableplugin=subscription-manager poppler-utils
RUN yum install -y --disableplugin=subscription-manager python36 python36-pip
RUN yum list --installed
RUN python3 --version