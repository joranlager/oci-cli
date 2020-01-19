#docker build -f Dockerfile -t fra.ocir.io/nose/consultingregistry/oci-cli:latest .
#docker push fra.ocir.io/nose/consultingregistry/oci-cli:latest

#docker run -it --rm --mount type=bind,source="%cd%",target=/root/.oci --env-file tenancy.env fra.ocir.io/nose/consultingregistry/oci-cli:latest /bin/bash

FROM oraclelinux:7-slim

MAINTAINER joran.lager@oracle.com

ARG OCI_CLI_VERSION=-2.6.13-1.el7
ARG OCI_SDK_VERSION=-2.6.5-1.el7

USER root

#PYTHON 3:
#RUN yum -y install vim iputils install gettext jq
#RUN yum -y install oraclelinux-developer-release-el7
#RUN yum -y install python36
#RUN yum -y install python-oci-cli${OCI_CLI_VERSION} python-oci-sdk${OCI_SDK_VERSION}
#RUN python3.6 -m venv py36ocienv && \
#source py36ocienv/bin/activate && \
#python -m pip install oci oci-cli --upgrade pip && \
#yum clean all && \
#rm -rf /var/cache/yum/* && \

# Setup the clients
COPY setup-clients.sh /oci/

ARG CACERT_PEM_URL=https://curl.haxx.se/ca/cacert.pem
ENV CURL_CA_BUNDLE=/oci/cacert.pem

# Install required Client packages
#https://docs.cloud.oracle.com/iaas/tools/oci-cli/latest/oci_cli_docs/?TocPath=Developer Tools |Command Line Interface (CLI) |_____6

RUN ln -s $(ls /harvest/setup-clients.sh) /usr/bin/setup-clients && \
yum -y install vim iputils install gettext jq oraclelinux-developer-release-el7 && \
yum -y install python-oci-cli${OCI_CLI_VERSION} python-oci-sdk${OCI_SDK_VERSION} && \
yum clean all && \
rm -rf /var/cache/yum/* && \
curl $CACERT_PEM_URL -o $CURL_CA_BUNDLE --insecure && \
ls -latr $CURL_CA_BUNDLE

ENV OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING=True
ENV OCI_TENANCY_NAME=
ENV OCI_TENANCY_OCID=
ENV OCI_USER_OCID=
ENV OCI_REGION=

VOLUME ["/oci"]
WORKDIR /oci

CMD ["/bin/bash"]
