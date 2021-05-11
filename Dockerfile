# oci-cli DOCKERFILE
# ------------------
# This Dockerfile creates a Docker image to be used to run OCI CLI.
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# docker build -f Dockerfile -t joranlager/oci-cli:2.24.3 .
# docker push joranlager/oci-cli:2.24.3

FROM oraclelinux:8-slim as builder

MAINTAINER joran.lager@oracle.com

ARG OCI_CLI_VERSION=2.24.3

USER root

RUN rm -f /etc/localtime && \
ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime && \
microdnf install -y unzip zip python3 python3-libs python3-pip python3-setuptools jq openssl --nodocs

RUN mkdir -p /oci && \
cd /oci && \
curl --insecure -L https://github.com/oracle/oci-cli/releases/download/v{$OCI_CLI_VERSION}/oci-cli-{$OCI_CLI_VERSION}.zip -o /oci/oci-cli-{$OCI_CLI_VERSION}.zip && \
unzip /oci/oci-cli-{$OCI_CLI_VERSION}.zip && \
cd /oci/oci-cli && pip3 install oci_cli-*-py2.py3-none-any.whl && \
rm -rf /oci && \
oci --version

# Setup the clients
COPY setup-oci.sh /oci/

RUN rm -f /etc/localtime && \
ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime && \
ln -s $(ls /oci/setup-oci.sh) /usr/bin/setup-oci && \
chmod 700 /oci/setup-oci.sh

WORKDIR /oci

CMD ["/bin/bash"]
