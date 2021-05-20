#!/bin/env bash

set -o errexit

. ./_utils.sh

function backup() {
    local container_name="${1}"
    local container_directory="${2}"

    echo "* Making backup of ${container_directory} from ${container_name}"

    local output_filename="${container_name}+$(printf ${container_directory} | sanitize_directory_name)+$(timestamp)"
    docker run --rm \
        --volumes-from "${container_name}" \
        --volume "$(pwd)/Backup:/backup" \
        ubuntu \
        tar --create --gzip \
            --file "/backup/${output_filename}.tar.gz" \
            --directory "${container_directory}" .
}

if [[ $# -ne 0 ]]; then
    backup "${@}"
else
    backup "docker_dokuwiki_1" "/bitnami/dokuwiki"
    # backup "docker_open_project_1" "/var/openproject/pgdata"
    # backup "docker_open_project_1" "/var/openproject/assets"
    backup "docker_xwiki_1" "/usr/local/xwiki"
    backup "docker_xwiki_db_1" "/var/lib/postgresql/data"
    backup "docker_redmine_1" "/usr/src/redmine/files"
    backup "docker_redmine_db_1" "/var/lib/postgresql/data"
fi
