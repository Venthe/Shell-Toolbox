#!/bin/env bash

set -o errexit
set -o pipefail

function is_java_decompiler_in_path() {
   bash -c 'which java-decompiler.jar &> /dev/null; printf ${?}'
}

# For GitBash
if [[ $(is_java_decompiler_in_path) -ne 0 ]]; then
    IDEA_PATH=$(env | grep 'IntelliJ IDEA=' | sed -e 's/IntelliJ IDEA=//g ; s/;//g ; s/\\/\//g ; s/://g')
    DECOMPILER_PATH=${DECOMPILER_PATH:-"/${IDEA_PATH}/../plugins/java-decompiler/lib"}
    JAVA_DECOMPILER=`printf "${DECOMPILER_PATH}/java-decompiler.jar"`
else
    JAVA_DECOMPILER=`which java_decompiler.jar`
fi

JAR_FILE="${1}"
# OUTPUT_DIR=$(printf "${JAR_FILE}" | sed -e 's/\.jar//g')
OUTPUT_DIR="${2}"

mkdir -p "${OUTPUT_DIR}"
echo "******* DECOMPILING ${JAR_FILE}! *******"
time "/C/Program Files/AdoptOpenJDK/jdk-11.0.9.101-hotspot/bin/java" -classpath "${JAVA_DECOMPILER}" org.jetbrains.java.decompiler.main.decompiler.ConsoleDecompiler \
-hdc=0 -dgs=1 -rsy=1 -rbr=1 -lit=1 -nls=1 -mpm=60 \
"${JAR_FILE}" "${OUTPUT_DIR}"
echo