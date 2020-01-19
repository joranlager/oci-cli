#!/bin/bash

# Running silent:
export tenancy_name=$OCI_TENANCY_NAME
export tenancy_ocid=$OCI_TENANCY_OCID
export user_ocid=$OCI_USER_OCID
export region=$OCI_REGION

export key_path="/root/.oci"
export key_name=$OCI_TENANCY_NAME
#https://github.com/terraform-providers/terraform-provider-oci/issues/712
#export key_passphrase="hello"

export private_key_file="${key_path}/${key_name}.pem"
export public_key_file="${key_path}/${key_name}_public.pem"

oci setup keys --key-name ${key_name} --output-dir ${key_path} --passphrase=${key_passphrase} --overwrite > ${key_path}/setupstatus.txt

#echo -e "\n" | oci setup keys --overwrite --key-name ${key_name} --output-dir ${key_path} --passphrase > ${key_path}/setupstatus.txt

#public key fingerprint:
export fingerprint=$(grep fingerprint ${key_path}/setupstatus.txt | cut -d ' ' -f4)
echo $fingerprint

echo -e "[DEFAULT]\nuser=${user_ocid}\nfingerprint=${fingerprint}\nkey_file=${private_key_file}\ntenancy=${tenancy_ocid}\nregion=${region}" > /root/.oci/config

echo "*********** oci config ***************"
cat /root/.oci/config

echo "Public key PEM:"
echo https://docs.cloud.oracle.com/Content/API/Concepts/apisigningkey.htm#How2
cat ${public_key_file}
