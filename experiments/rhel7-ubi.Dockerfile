FROM registry.access.redhat.com/ubi7/ubi:7.7
#RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/RHEL_7/ && yum update && yum install tesseract && yum install tesseract-langpack-deu
RUN yum update -y
RUN yum install -y gcc
RUN yum install -y g++
RUN yum install -y poppler-utils
RUN yum list installed
