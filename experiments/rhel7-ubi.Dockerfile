FROM registry.access.redhat.com/ubi7/ubi-minimal:7.7-98
RUN yum list installed
RUN yum list available
RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/RHEL_7/ && yum update && yum install tesseract && yum install tesseract-langpack-deu
RUN yum install poppler-utils