FROM registry.access.redhat.com/ubi7/ubi-minimal:latest

RUN yum -y install @development
RUN yum -y install rh-python36