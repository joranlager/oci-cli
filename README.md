# oci-cli - containerized OCI CLI

## Running the OCI CLI

The current directory will be used to store your OCI CLI certificate and key, so mount it when running the OCI CLI.

### Creating the tenancy.env file
Also make sure pass the tenancy.env file to the container setting the properties within that file as ENV variables in the container.
Make sure to set proper values for the entries in that file.
The values can be found using the Oracle Cloud Infrastructure web UI.

### Create the file tenancy.env
bash
```
cat << EOF > mytenancy.env
OCI_TENANCY_NAME=mytenancy
OCI_TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaaflf2uasrxxxqvwvvbcmvuk52fndxxxs3byra
OCI_USER_OCID=ocid1.user.oc1..aaaaaaaanufslfkvk7rnjjxxxv6uupomxxxxhda
OCI_REGION=eu-frankfurt-1
EOF
```

### Running the container in interactive mode
bash
```
docker run -it --rm --mount type=bind,source="$(pwd)",target=/root/.oci --env-file mytenancy.env joranlager/oci-cli /bin/bash
```

Windows Command Line
```
docker run -it --rm --mount type=bind,source="%cd%",target=/root/.oci --env-file mytenancy.env joranlager/oci-cli /bin/bash
```

#### Creating and setting the required certificate and key to access OCI
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
oci iam compartment list --all | jq '.data[] | .name + " (" + .description + ") OCID: " + .id'
```

## Building the image

This image has no external dependencies. It can be built using the standard`docker build` command, as follows: 

```
docker build -f Dockerfile -t joranlager/oci-cli:latest .
```

### Manually specifying versions

Here is an example command that uses a specific version of OCI CLI:

```
docker build -f Dockerfile -t joranlager/oci-cli:2.21.3 --build-arg OCI_CLIENT_VERSION="2.21.3" .
```
