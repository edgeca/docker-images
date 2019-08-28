FROM registry.access.redhat.com/ubi7/ubi:7.7
RUN yum update -y
RUN yum install -y devtoolset-7
RUN yum install -y poppler-utils
RUN yum list installed
