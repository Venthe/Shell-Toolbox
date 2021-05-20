#!/usr/bin/env bash

set -x

mvn install:install-file -Dfile=src/main/resources/atlassian-extras-decoder-v2-3.4.1.jar -DgroupId=com.atlassian -DartifactId=extras-decoder -Dversion=3.4.1 -Dpackaging=jar
mvn install:install-file -Dfile=src/main/resources/atlassian-extras-3.3.0.jar -DgroupId=com.atlassian -DartifactId=extras -Dversion=3.3.0 -Dpackaging=jar

#function decompile() {
#  local TARGET_PATH="${1}"
#  ls ${TARGET_PATH}/*.jar | xargs -n 1 -I{} ./decompile.sh {} ./temp
#  for file in ./temp/*.jar; do
#    echo "Renaming ${file}"
#    mv "${file}" "${file%.jar}-sources.jar"
#  done
#  mv ./temp/*-sources.jar ${TARGET_PATH}/
#}
#
#mkdir temp -p
#
#decompile "./confluence/dependencies/WEB-INF/lib"
