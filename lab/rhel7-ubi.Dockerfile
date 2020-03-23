FROM registry.access.redhat.com/ubi7/ubi:latest

RUN yum install --disableplugin=subscription-manager bzip2
RUN yum -y install @development
RUN yum -y install rh-python36