# oci-cli - containerized OCI CLI

## Configuring access to Docker images from ocir
If no access to a private Docker Registry is required, 
please ignore the steps described here related to accessing the Docker images at fra.ocir.io.
You then have to build the Docker image in your local Docker engine (See "Building the image" below).

### Login to the tenancy and create an Auth token for your user
In order to pull, run and push Docker images from / to the nose / consultingregistry, login is required.

1. Log in to the Oracle Cloud using a browser (https://console.eu-frankfurt-1.oraclecloud.com)
2. Navigate to Profile -> <user>, then select Resources -> Auth Tokens and Generate Token.
3. Enter "noseconsultingregistrytoken" in description and click the Generate Token button.
4. Then copy the generated token and store it somewhere safe.

It looks like this:
```
eVXR({cRt;MLqYcAAA;3
```

### Login to the private Docker registry using your user and the Auth token generated
```
docker login -u nose/oracleidentitycloudservice/joran.lager@oracle.com -p eVXR({cRt;MLqYcAAA;3 fra.ocir.io
```

## Running the OCI CLI

The current directory will be used to store your OCI CLI certificate and key, so mount it when running the OCI CLI.

### Creating the tenancy.env file
Also make sure pass the tenancy.env file to the container setting the properties within that file as ENV variables in the container.
Make sure to set proper values for the entries in that file.
The values can be found using the Oracle Cloud Infrastructure web UI.

```
OCI_TENANCY_NAME=nose
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaaflfxxx
OCI_USER_OCID=ocid1.user.oc1..aaaaaaaanufslfkvkyyy
OCI_REGION=eu-frankfurt-1
```

### Running the container in interactive mode
```
docker run -it --rm --mount type=bind,source="%cd%",target=/root/.oci --env-file tenancy.env fra.ocir.io/nose/consultingregistry/oci-cli:latest /bin/bash
```

### Creating and setting the required certificate and key to access OCI
For inital setup of the OCI CLI credentials / certificate of if you need to re-configure, run the setup-oci command in the container shell.
This will overwrite existing certificate and private key so make sure that is the intention.
```
setup-oci
```
Running the script requires the user to hit enter when the script pauses - then the public key in PEM format is displayed.
That content must be added as public authentication key for the given user:
1. Log in to the Oracle Cloud using a browser (https://console.eu-frankfurt-1.oraclecloud.com)
2. Navigate to Profile -> <user>, then select Resources -> API Keys and Add Public Key.
3. Paste the public key in PEM format and push Add button.

Then, within that shell, run OCI CLI commands as usual:
```
oci iam compartment list --all
```

## Building the image

This image has no external dependencies. It can be built using the standard`docker build` command, as follows: 

```
docker build -f Dockerfile -t fra.ocir.io/nose/consultingregistry/oci-cli:0.1 .
docker tag fra.ocir.io/nose/consultingregistry/oci-cli:0.1 fra.ocir.io/nose/consultingregistry/oci-cli:latest
```

### Manually specifying versions

Here is an example command that uses a specific version of OCI CLI and SDK:

```
docker build -f Dockerfile -t fra.ocir.io/nose/consultingregistry/oci-cli:0.1 --build-arg OCI_CLIENT_VERSION="-2.6.13-1.el7" --build-arg OCI_SDK_VERSION="-2.6.5-1.el7" .
```

