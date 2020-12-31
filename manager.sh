#!/bin/env bash

ROOT_SUBJECT_FILE="root_subject.txt"
CSR_SUBJECT_FILE="csr_subject.txt"
ENCRYPTION_BITS=1024
OUTPUT_DIR="${OUTPUT_DIR:-./}"

function label() {
    echo -e "  * ${@}"
}

function generate_passphrase() {
    local passphrase_path="${OUTPUT_DIR}/${1}.passphrase"
    label "Generating passphrase: ${passphrase_path}"
    openssl rand -base64 14 | head -n 1 | tr -d '\n' > "${passphrase_path}"
}

function clean() {
    label "Cleaning directory ${OUTPUT_DIR}"
    local working_dir=$(pwd)
    cd "${OUTPUT_DIR}"
    rm "*.pem" \
        "*.key" \
        "*.srl" \
        "*.ext" \
        "*.csr" \
        "*.crt" \
        "*.passphrase" \
        2> /dev/null || true
    cd "${working_dir}"
}

function generate_key() {
    local key_file="${OUTPUT_DIR}/${1}.key"
    local passphrase_file="${OUTPUT_DIR}/${1}.passphrase"
    label "Generating key ${key_file} with passphrase ${passphrase_file}"
    openssl genrsa \
            -des3 \
            -passout file:"${passphrase_file}" \
            -out "${key_file}" \
            ${ENCRYPTION_BITS}
}

function decrypt_key() {
    local key_file="${OUTPUT_DIR}/${1}.key"
    local passphrase_file="${OUTPUT_DIR}/${1}.passphrase"
    label "Decrypting key ${key_file} with passphrase ${passphrase_file}"
    openssl rsa -in "${key_file}" --passin file:"${passphrase_file}"
}

function read_crt() {
    local file="${OUTPUT_DIR}/${1}.crt"
    openssl x509 -in "${file}" -text -noout
}

function generate_ca() {
    local key_file="${OUTPUT_DIR}/${1}.key"
    local output_file="${OUTPUT_DIR}/${1}.crt"
    local passphrase_file="${OUTPUT_DIR}/${1}.passphrase"
    shift 1
    label "Generating CA ${output_file} with passphrase ${passphrase_file} and key ${key_file}"
    openssl req \
        -x509 \
        -new \
        -nodes \
        -key "${key_file}" \
        -sha512 \
        -passin file:"${passphrase_file}" \
        -days 1825 \
        -out "${output_file}" \
        "${@}"
}

function generate_csr() {
    local key_file="${OUTPUT_DIR}/${1}.key"
    local csr_file="${OUTPUT_DIR}/${1}.csr"
    local passphrase_file="${OUTPUT_DIR}/${1}.passphrase"
    shift 1
    label "Generating Certificate Signing Request ${csr_file} with passphrase ${passphrase_file} and key ${key_file}"
    openssl req \
            -new \
            -key "${key_file}" \
            -passin file:"${passphrase_file}" \
            -out "${csr_file}" \
            "${@}"
}

function generate_ext() {
    local ext_file="${OUTPUT_DIR}/${1}.ext"
    label "Generating EXT ${ext_file}"
    printf "${2}" | cat > "${ext_file}"
}

function sign_csr() {
    local signer_key="${OUTPUT_DIR}/${1}.key"
    local signer_passphrase="${OUTPUT_DIR}/${1}.passphrase"
    local signer_certificate="${OUTPUT_DIR}/${1}.crt"

    local signee_csr="${OUTPUT_DIR}/${2}.csr"
    local signee_ext="${OUTPUT_DIR}/${2}.ext"
    local signee_certificate="${OUTPUT_DIR}/${2}.crt"
    label "Signing intermediate certificate signee ${2} with signer ${1}"
    shift 2
    openssl x509 \
        -req \
        -in "${signee_csr}" \
        -CA "${signer_certificate}" \
        -CAkey "${signer_key}" \
        -CAcreateserial \
        -out "${signee_certificate}" \
        -passin file:"${signer_passphrase}" \
        -days 825 \
        -sha512 \
        -extfile "${signee_ext}" \
        "${@}"
}

"${@}"