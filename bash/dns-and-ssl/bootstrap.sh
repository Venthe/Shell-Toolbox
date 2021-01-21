#!/bin/env bash

set -e

DOMAIN="example.org"
export OUTPUT_DIR=output
CSR_SUBJECT="/C=PL/ST=Mazovia/L=Warsaw/O=Jacek Lipiec Business Consulting/CN=*.${DOMAIN}, emailAddress=jacek.lipiec.bc@gmail.com"

mkdir -p output
./manager.sh clean
./manager.sh generate_passphrase "root"
./manager.sh generate_key "root"
./manager.sh decrypt_key "root"
./manager.sh generate_ca "root" \
    -subj "${CSR_SUBJECT}"
./manager.sh read_crt "root"
./manager.sh generate_passphrase "${DOMAIN}"
./manager.sh generate_key "${DOMAIN}"
./manager.sh decrypt_key "${DOMAIN}"
./manager.sh generate_csr "${DOMAIN}" \
    -subj "${CSR_SUBJECT}"
./manager.sh generate_ext "${DOMAIN}" \
'authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:TRUE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment'
./manager.sh sign_csr "root" "${DOMAIN}"
./manager.sh read_crt "${DOMAIN}"