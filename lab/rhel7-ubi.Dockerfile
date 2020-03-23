FROM registry.access.redhat.com/ubi7/ubi:latest

RUN yum install -y --disableplugin=subscription-manager poppler-utils
#RUN yum install -y --disableplugin=subscription-manager @development
RUN yum install -y --disableplugin=subscription-manager rh-python36
RUN yum list installed
RUN python3 --version
RUN pip3 install opencv-python