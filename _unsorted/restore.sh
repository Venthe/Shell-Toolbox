#!/bin/env bash

set -o errexit

. ./_utils.sh

function restore {
    local container_name="${1}"
    local container_directory="${2}"

    echo "* Restoring ${container_name} to ${container_directory}"

    local latest_backup=$(get_latest_backup "${container_name}" "${container_directory}")

    docker run --rm \
        --volumes-from "${container_name}" \
        --volume "$(pwd)/Backup:/backup" \
        ubuntu \
        bash -c "cd ${container_directory} && rm --recursive --force ./* && tar --extract --ungzip --file /backup/${latest_backup}"
}

function get_latest_backup() {
    local container_name="${1}"
    local container_directory="${2}"
    local sanitized_directory="$(printf ${container_directory} | sanitize_directory_name)"

    ls "./Backup" -l -1r \
        | grep "${container_name}" \
        | grep "${sanitized_directory}" \
        | head -n 1 \
        | awk '{print $9}'
}

if [[ $# -ne 0 ]]; then
    restore "${@}"
else
    restore "docker_dokuwiki_1" "/bitnami/dokuwiki"
    # restore "docker_open_project_1" "/var/openproject/pgdata"
    # restore "docker_open_project_1" "/var/openproject/assets"
    restore "docker_xwiki_1" "/usr/local/xwiki"
    restore "docker_xwiki_db_1" "/var/lib/postgresql/data"
    restore "docker_redmine_1" "/usr/src/redmine/files"
    restore "docker_redmine_db_1" "/var/lib/postgresql/data"
fi
