#!/usr/bin/env bash

# set -o xtrace

_TEMP_DIR="temp"

rm -rf ./"${_TEMP_DIR}"
mkdir "${_TEMP_DIR}"

function download() {
    local PREFIX="${2}"
    local CUR_DIR
    CUR_DIR=$(pwd)
    local ORIGINAL_FILE_NAME
    ORIGINAL_FILE_NAME=$(basename "${1}")
    if [ -n "$2" ]; then
        local FINAL_FILE_NAME="$PREFIX$ORIGINAL_FILE_NAME"
    else
        local FINAL_FILE_NAME="$ORIGINAL_FILE_NAME"
    fi
    echo "downloading $FINAL_FILE_NAME"
    cd "${_TEMP_DIR}" || exit 1
    curl "${1}" \
        --remote-name \
        --remote-header-name \
        --silent \
        --location \
        --show-error
    if [[ ! -f "$FINAL_FILE_NAME" ]]; then
        mv "$ORIGINAL_FILE_NAME" "$FINAL_FILE_NAME"
    fi
    cd "${CUR_DIR}" || exit 1
}

download "https://github.com/git-for-windows/git/releases/download/v2.27.0.windows.1/Git-2.27.0-64-bit.exe"
download "https://aka.ms/win32-x64-user-stable" "vscode-"
download "https://www.7-zip.org/a/7z1900-x64.msi"
download "https://download.tortoisegit.org/tgit/2.10.0.0/TortoiseGit-2.10.0.2-64bit.msi"
download "https://osdn.net/frs/redir.php?m=dotsrc&f=%2Fstorage%2Fg%2Ft%2Fto%2Ftortoisesvn%2F1.14.0%2FApplication%2FTortoiseSVN-1.14.0.28885-x64-svn-1.14.0.msi"
