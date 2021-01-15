#!/usr/bin/bash

# TODO: Code coverage
# TODO: Cyclomatic complexity
# TODO: Cognitive complexity
# TODO: Churn

function _git() {
    # Returns last tag-number of commits since last tag-abbr of hash
    function describe_head() {
        git describe "${@}"
    }

    function commits_per_user() {
        git shortlog --summary --email "${@}"
    }

    function commit_count() {
        git rev-list HEAD --count "${@}"
    }

    function all_commits() {
        git --no-pager log HEAD --pretty=format:"%H" --reverse "${@}" 
    }
    
    function files_to_verify() {
        git diff HEAD~1..HEAD --name-status "${@}" \
        | sed '/^D/d' \
        | awk '{print $2}'
    }

    function this() {
        git "${@}"
    }

    function lines_per_filetype() {
        git ls-files \
        | xargs wc --lines \
        | sed '/total$/d' \
        | sed -e 's/^\s*//g' \
        | sed -e 's/\s/ \//g' \
        | sed -E 's/([\/].*[\/])//g' \
        | sed -E 's/([ ]{1}.+\.)/ /g' \
        | awk '{
            arr[$2]+=$1
        }
        END {
            for (key in arr) printf("{\"extension\":\"%s\", \"linesOfCode\":%s}\n", key, arr[key])
        }' \
        | jq \
            --slurp \
            --monochrome-output \
            --compact-output \
                '.[] |= {(.extension|tostring): .linesOfCode} | add' \
        | jq_with_rev
    }

    "${@}"
}

function docker_run() {
    docker run --rm \
        --interactive \
        "${@}"
}

function yq() {
    docker_run \
        --volume="${PWD}:/workdir" \
        mikefarah/yq "${@}"
}

function xq() {
    docker_run \
        --workdir="/workdir" \
        --volume="${PWD}:/workdir" \
        alpine/xml xq .
}

function jq() {
    docker_run \
        --workdir="/workdir" \
        --volume="${PWD}:/workdir" \
        imega/jq "${@}"
}

function jq_with_rev() {
    jq \
            --slurp \
            --arg REV "$(git rev-parse HEAD)" \
            --monochrome-output \
            --compact-output \
                '{output: .} | .revision=$REV'
}

function stats() {
    docker_run \
        --volume="${PWD}:/git" \
        arzzen/git-quick-stats \
        "${@}"
}

function pmd() {
    function _pmd() {
        docker_run \
            --volume="${PWD}:/src" \
            rawdee/pmd \
            pmd -language java \
                -format xml \
                -no-cache \
                -rulesets rulesets/java/quickstart.xml \
                "${@}" \
                | xq \
                | jq_with_rev
    }

    function last_commit() {
        _git files_to_verify | grep .java | paste -d, -s > pmd_input
        _pmd -filelist pmd_input "${@}" 
        rm pmd_input 
    }

    function all() {
        _pmd -dir . "${@}"
    }

    "${@}"
}

function cpd() {
    function _cpd() {
        docker_run \
            --volume="${PWD}:/src" \
            rawdee/pmd \
            cpd --format xml \
                --minimum-tokens 50 \
                "${@}" \
                | xq \
                | jq_with_rev
    }

    function last_commit() {
        _git files_to_verify | grep .java | paste -d, -s > pmd_input
        _cpd --filelist pmd_input "${@}" 
        rm pmd_input 
    }

    function all() {
        _cpd --files . "${@}"
    }

    "${@}"
}

function checkstyle() {
    function _checkstyle() {
        docker_run \
            --volume="${PWD}:/checkstyle/workdir" \
            venthe/checkstyle \
            -f xml \
            -c /checkstyle/rules/google_checks.xml \
            "${@}" \
            | xq  \
            | jq_with_rev
    }

    function last_commit() {
        FILES=$(_git files_to_verify | xargs)
        _checkstyle $FILES "${@}"
    }

    function all() {
        _checkstyle ./ "${@}"
    }

    "${@}"
}

function spotbugs() {
    docker_run --name spotbugs \
        --volume="${PWD}:/spotbugs/workdir" \
        venthe/spotbugs \
        -textui -quiet -sarif "${@}" ./ \
        | jq_with_rev
}

function mvn() {
    docker_run --name maven \
        --volume="${PWD}:/usr/project" \
        --volume="${HOME}/.m2":/root/.m2 \
        --workdir="/usr/project" \
        maven mvn "${@}"
}

function gource() {
#   --volume=AVATARS_FOLDER:/avatars \
#   --volume=MP3_FOLDER:/mp3s \
    docker_run --name gource \
  --volume="${PWD}:/repos" \
  --volume="${PWD}:/results" \
  --env GOURCE_ARGS="title='My awesome project'" \
  sandrokeil/gource
}

function churn() {
    function files() {
        git ls-tree -r --name-only HEAD | sed '/\.xml/d'
    }

    function object() {
        FILENAME="${1}"
        shift 1
        
        TIMES_CHANGED=$(git log --format=oneline "${FILENAME}" | wc -l)
        if [[ $TIMES_CHANGED -le 10 ]]; then
            exit
        fi

        LOC=$(wc --lines ${FILENAME}| awk '{print $1}')

        echo "$FILENAME;$TIMES_CHANGED;$LOC"

        # jq --null-input \
        # --monochrome-output \
        # --compact-output \
        # --arg LOC $LOC \
        # --arg TIMES_CHANGED $TIMES_CHANGED \
        # --arg FILENAME $FILENAME \
        # '{} | .filename=$FILENAME | .timesChanged=($TIMES_CHANGED|tonumber) | .linesOfCode=($LOC|tonumber)'
    }

    files \
        | xargs -I @ -n1 bash -c "$(declare -f object); object @" 
        # \
        # | jq \
        #     --slurp \
        #     --monochrome-output \
        #     --compact-output
}

(cd "${1}"; shift 1; "${@}")
