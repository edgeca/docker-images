FROM registry.access.redhat.com/ubi7/ubi:latest

RUN yum install -y --disableplugin=subscription-manager poppler-utils
#RUN yum install -y --disableplugin=subscription-manager @development
RUN yum install -y --disableplugin=subscription-manager rh-python36
RUN yum list installed
RUN python --version
RUN pip install opencv-python