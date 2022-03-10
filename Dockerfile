# oci-cli DOCKERFILE
# ------------------
# This Dockerfile creates a Docker image to be used to run OCI CLI.
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# docker build -f Dockerfile -t joranlager/oci-cli:3.6.0 .
# docker tag joranlager/oci-cli:3.0.1 joranlager/oci-cli:latest
# docker push joranlager/oci-cli:3.0.1
# docker push joranlager/oci-cli:latest

FROM oraclelinux:8-slim as builder

MAINTAINER joran.lager@oracle.com

USER root

RUN rm -f /etc/localtime && \
ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime && \
microdnf install -y unzip zip python3 python3-libs python3-pip python3-setuptools jq openssl --nodocs

ARG OCI_CLI_VERSION=3.6.0

RUN mkdir -p /oci && \
cd /oci && \
curl --insecure -L https://github.com/oracle/oci-cli/releases/download/v{$OCI_CLI_VERSION}/oci-cli-{$OCI_CLI_VERSION}.zip -o /oci/oci-cli-{$OCI_CLI_VERSION}.zip && \
unzip /oci/oci-cli-{$OCI_CLI_VERSION}.zip && \
export CRYPTOGRAPHY_DONT_BUILD_RUST=1 && \
pip3 install --upgrade pip && \
pip3 install cryptography && \
cd /oci/oci-cli && pip3 install oci_cli-*-py3-none-any.whl && \
rm -rf /oci && \
oci --version

# Setup the clients
COPY setup-oci.sh /oci/

RUN rm -f /etc/localtime && \
ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime && \
ln -s $(ls /oci/setup-oci.sh) /usr/bin/setup-oci && \
chmod 700 /oci/setup-oci.sh

ENV OCI_CLI_SUPPRESS_FILE_PERMISSIONS_WARNING=True

WORKDIR /oci

CMD ["/bin/bash"]
