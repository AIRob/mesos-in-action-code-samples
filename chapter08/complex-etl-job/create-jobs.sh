#!/bin/bash

if [[ ! $# > 0 ]]; then
    echo "Usage: $0 <http://chronos-host:4400>"
    echo
    exit 1
else
    CHRONOS_URL=$1
fi

DIR=$(dirname "${BASH_SOURCE}")
CURL=""

for job in "${DIR}"/*.json; do
    echo -n "Creating job ${job} in Chronos..."

    if grep \"schedule\" "${job}" > /dev/null; then
        curl -H 'Content-Type: application/json' -d @${job} ${CHRONOS_URL}/scheduler/iso8601
        [[ $? == 0 ]] && echo "Done." || echo "Error!"
    elif grep \"parents\" "${job}" > /dev/null; then
        curl -H 'Content-Type: application/json' -d @${job} ${CHRONOS_URL}/scheduler/dependency
        [[ $? == 0 ]] && echo "Done." || echo "Error!"
    else
        echo "Error: could not determine job type for '${job}'"
    fi
done

