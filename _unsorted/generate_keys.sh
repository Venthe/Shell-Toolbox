#!/usr/bin/env bash

# Script to generate certificate chain for private purposes
# See: https://jamielinux.com/docs/openssl-certificate-authority/create-the-root-pair.html

# TODO:
# * Verify
# * Add SAN
# * Convert all SSL commands to use openssl req

set -o xtrace
set -o nounset
set -o errexit
set -o pipefail

function generate_key() {
    openssl genrsa -aes256 -passout "file:${2}" -out "${1}" 4096
    chmod 400 "${1}"
}

function generate_unprotected_key() {
    openssl genrsa -out "${1}" 2048
    chmod 400 "${1}"
}

function check_key() {
    openssl rsa -in "${1}" -check -passin "file:${2}"
}

function read_pem() {
    openssl x509 -text -noout -in "${1}"
}

function read_csr() {
    openssl req -text -noout -in "${1}"
}

if [[ $# -gt 0 ]]; then
    "${@}"
    exit 0
fi

# Prepare directories
## Clean directories related to keys
rm --recursive --force "temp"

OUTPUT_DIRECTORY="temp"

# Create timestamp
# touch "temp/$(date +%X%d%m%y | base64)"

# Generate root CA
ROOT_CA_SECRET="rootCA.secret"
ROOT_CA_CNF="rootCA.cnf"
ROOT_CA_KEY="${OUTPUT_DIRECTORY}/ca/private/ca.key.pem"
ROOT_CA_PEM="${OUTPUT_DIRECTORY}/ca/certs/ca.cert.pem"

## Create a directory to store all keys and certificates.
mkdir --parents "${OUTPUT_DIRECTORY}/ca/"{certs,crl,newcerts,private}
chmod 700 "${OUTPUT_DIRECTORY}/ca/private"
## The index.txt and serial files act as a flat file database to keep track of signed certificates.
touch "${OUTPUT_DIRECTORY}/ca/index.txt"
printf 1000 > "${OUTPUT_DIRECTORY}/ca/serial"

## Keep this file absolutely secure. Anyone in possession of the root key can issue trusted certificates.
generate_key "${ROOT_CA_KEY}" "${ROOT_CA_SECRET}"
check_key "${ROOT_CA_KEY}" "${ROOT_CA_SECRET}"
## Generate root CA
## With 4096 bits of encryption, microsoft suggests validity up to 16 years, and cert should be substituted
## in around half of that time
SUBJECT="/countryName=PL/stateOrProvinceName=Mazovia/organizationName=Jacek Lipiec Business Consulting/organizationalUnitName=Test/commonName=JLBC CA/emailAddress=jacek.lipiec.bc@gmail.com/"
openssl req -x509 --extensions v3_ca -config "${ROOT_CA_CNF}" -new -sha512 -days "5840" \
    -subj "${SUBJECT}" \
    -key "${ROOT_CA_KEY}" -passin "file:${ROOT_CA_SECRET}" \
    -out "${ROOT_CA_PEM}"
chmod 444 "${ROOT_CA_PEM}"
read_pem "${ROOT_CA_PEM}"

# Generate intermediate CA
SUBJECT="/countryName=PL/stateOrProvinceName=Mazovia/organizationName=Jacek Lipiec Business Consulting/organizationalUnitName=Test/commonName=JLBC intermediate CA/emailAddress=jacek.lipiec.bc@gmail.com/"

INTERMEDIATE_CA_SECRET="intermediateCA.secret"
INTERMEDIATE_CA_CNF="intermediateCA.cnf"
INTERMEDIATE_CA_KEY="${OUTPUT_DIRECTORY}/ca/intermediate/private/intermediate.key.pem"
INTERMEDIATE_CA_PEM="${OUTPUT_DIRECTORY}/ca/intermediate/certs/intermediate.cert.pem"
INTERMEDIATE_CA_CSR="${OUTPUT_DIRECTORY}/ca/intermediate/csr/intermediateCA.csr"
INTERMEDIATE_CA_CHAIN_PEM="${OUTPUT_DIRECTORY}/ca/intermediate/certs/intermediate.chain.pem"

mkdir --parents "${OUTPUT_DIRECTORY}/ca/intermediate/"{certs,crl,csr,newcerts,private}
chmod 700 "${OUTPUT_DIRECTORY}/ca/intermediate/private"
touch "${OUTPUT_DIRECTORY}/ca/intermediate/index.txt"
printf 1000 > "${OUTPUT_DIRECTORY}/ca/intermediate/serial"
# crlnumber is used to keep track of certificate revocation lists.
printf 1000 > "${OUTPUT_DIRECTORY}/ca/intermediate/crlnumber"

## Generate intermediate CA
# generate_key "${INTERMEDIATE_CA_KEY}" "${INTERMEDIATE_CA_SECRET}"
generate_unprotected_key "${INTERMEDIATE_CA_KEY}"
## Generate CSR
    # -key "${INTERMEDIATE_CA_KEY}" -passin "file:${INTERMEDIATE_CA_SECRET}" \
openssl req -config "${INTERMEDIATE_CA_CNF}" -new -sha512 \
    -subj "${SUBJECT}" \
    -key "${INTERMEDIATE_CA_KEY}" \
    -out "${INTERMEDIATE_CA_CSR}"
read_csr "${INTERMEDIATE_CA_CSR}"
openssl ca -config "${INTERMEDIATE_CA_CNF}" -extensions v3_intermediate_ca \
      -days 2920 -notext -md sha256 -batch \
      -keyfile "${ROOT_CA_KEY}" -passin "file:${ROOT_CA_SECRET}" \
      -cert "${ROOT_CA_PEM}" \
      -in "${INTERMEDIATE_CA_CSR}" \
      -out "${INTERMEDIATE_CA_PEM}"
read_pem "${INTERMEDIATE_CA_PEM}"

## Verify chain of trust
openssl verify -CAfile "${ROOT_CA_PEM}" \
      "${INTERMEDIATE_CA_PEM}"

## Create chain
cat "${INTERMEDIATE_CA_PEM}" \
      "${ROOT_CA_PEM}" > "${INTERMEDIATE_CA_CHAIN_PEM}"
chmod 444 "${INTERMEDIATE_CA_CHAIN_PEM}"

# Generate registry PEM
SUBJECT="/countryName=PL/stateOrProvinceName=Mazovia/organizationName=Jacek Lipiec Business Consulting/organizationalUnitName=Test/commonName=www.registry/emailAddress=jacek.lipiec.bc@gmail.com/"

REGISTRY_SECRET="registry.secret"
REGISTRY_CNF="registry.cnf"
REGISTRY_KEY="${OUTPUT_DIRECTORY}/ca/intermediate/private/registry.key.pem"
REGISTRY_PEM="${OUTPUT_DIRECTORY}/ca/intermediate/certs/registry.cert.pem"
REGISTRY_CSR="${OUTPUT_DIRECTORY}/ca/intermediate/csr/registry.csr"
# INTERMEDIATE_CA_CHAIN_PEM="${OUTPUT_DIRECTORY}/ca/intermediate/certs/intermediate.chain.pem"

generate_unprotected_key "${REGISTRY_KEY}"
openssl rsa -in "${REGISTRY_KEY}"

    # -config "${INTERMEDIATE_CA_CNF}" \
openssl req -sha512 -new \
    -config "${REGISTRY_CNF}" \
    -subj "${SUBJECT}" \
    -key "${REGISTRY_KEY}" -passin "file:${INTERMEDIATE_CA_SECRET}" \
    -out "${REGISTRY_CSR}"

openssl ca -config "${INTERMEDIATE_CA_CNF}" \
        -batch \
      -extensions server_cert -days 375 -notext -md sha512 \
      -keyfile "${INTERMEDIATE_CA_KEY}" -passin "file:${INTERMEDIATE_CA_SECRET}" \
      -in "${REGISTRY_CSR}" \
      -out "${REGISTRY_PEM}"
chmod 444 "${REGISTRY_PEM}"
read_pem "${REGISTRY_PEM}"
openssl verify -CAfile ${INTERMEDIATE_CA_CHAIN_PEM} \
    "${REGISTRY_PEM}"

rm --recursive --force "nginx/certs/"
mkdir --parents "nginx/certs"

cp "${REGISTRY_KEY}" "nginx/certs/registry.key"
# Generate chain 'domain name' notation for order and copy to NGINX
cat "${REGISTRY_PEM}" "${INTERMEDIATE_CA_CHAIN_PEM}" > "nginx/certs/registry.pem"

# Create and copy cryptography params. Use 4096 for production
openssl dhparam -out "nginx/certs/dhparams.pem" 1024