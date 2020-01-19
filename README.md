# Containerized OCI CLI

## Building the image

This image has no external dependencies. It can be built using the standard`docker build` command, as follows: 

```
docker build -f Dockerfile -t fra.ocir.io/nose/consultingregistry/oci-cli:latest .
```

### Manually specifying versions

Here is an example command that uses a specific version of OCI CLI and SDK:

```
docker build -f Dockerfile -t fra.ocir.io/nose/consultingregistry/oci-cli:latest --build-arg OCI_CLIENT_VERSION="-2.6.13-1.el7" --build-arg OCI_SDK_VERSION="-2.6.5-1.el7" .
```

## Running the OCI CLI

The current directory will be used to store your OCI CLI certificate and key, so mount it when running the OCI CLI.

### Creating the tenancy.env file
Also make sure pass the tenancy.env file to the container setting the properties within that file as ENV variables in the container.
Make sure to set proper values for the entries in that file.
The values can be found using the Oracle Cloud Infrastructure web UI.

```
OCI_TENANCY_NAME=nose
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaaflf2uasr2shm5ag2yulp4gjy3aoqvwvvbcmvuk52fndnkps3byra
OCI_USER_OCID=ocid1.user.oc1..aaaaaaaanufslfkvk7rnjju4f4bxb3qwor3toxpgkzev6uupomqwgjxpxhda
OCI_REGION=eu-frankfurt-1
```

### Creating and setting the required certificate and key to access OCI
For inital setup of the OCI CLI credentials / certificate of if you need to re-configure, run the setup-oci.sh.
This will overwrite existing certificate and private key so make sure that is the intention.

Running the script requires the user to hit enter when the script pauses - then the public key in PEM format is displayed.
That content must be added as public authentication key for the given user.

```
docker run -it --rm --mount type=bind,source="%cd%",target=/root/.oci --env-file tenancy.env fra.ocir.io/nose/consultingregistry/oci-cli:latest /bin/bash

setup-oci
```

Then, within that shell, run OCI CLI commands as usual:
```
oci iam compartment list --all
```
