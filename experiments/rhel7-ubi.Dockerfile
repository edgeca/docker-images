FROM registry.access.redhat.com/ubi7/ubi:7.7
RUN yum list installed
RUN yum list available
#RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/RHEL_7/ && yum update && yum install tesseract && yum install tesseract-langpack-deu
RUN yum update
RUN yum install gcc-g++
RUN yum install poppler-utils