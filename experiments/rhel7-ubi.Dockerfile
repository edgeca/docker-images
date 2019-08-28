FROM registry.access.redhat.com/ubi7/ubi:7.7
#RUN yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/Alexander_Pozdnyakov/RHEL_7/ && yum update && yum install tesseract && yum install tesseract-langpack-deu
RUN subscription-manager repos --enable rhel-7-server-optional-rpms \
  --enable rhel-server-rhscl-7-rpms \
  --enable rhel-7-server-devtools-rpms
RUN cd /etc/pki/rpm-gpg
RUN wget -O RPM-GPG-KEY-redhat-devel https://www.redhat.com/security/data/a5787476.txt
RUN rpm --import RPM-GPG-KEY-redhat-devel
RUN yum update -y
RUN yum install -y devtoolset-7
RUN yum install -y poppler-utils
RUN yum list installed
