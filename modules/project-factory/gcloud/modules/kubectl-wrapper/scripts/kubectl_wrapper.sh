#!/bin/bash

set -xeo pipefail

if [ "$#" -lt 5 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

CLUSTER_NAME=$1
LOCATION=$2
PROJECT_ID=$3
INTERNAL=$4
USE_EXISTING_CONTEXT=$5

shift 5

if $USE_EXISTING_CONTEXT ;then

    "$@"

else

    RANDOM_ID="${RANDOM}_${RANDOM}"
    export TMPDIR="/tmp/kubectl_wrapper_${RANDOM_ID}"

    function cleanup {
        rm -rf "${TMPDIR}"
    }
    trap cleanup EXIT

    mkdir "${TMPDIR}"

    export KUBECONFIG="${TMPDIR}/config"

    LOCATION_TYPE=$(grep -o "-" <<< "${LOCATION}" | wc -l)

    CMD="gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT_ID}"

    if [[ $LOCATION_TYPE -eq 2 ]] ;then
        CMD+=" --zone ${LOCATION}"
    else
        CMD+=" --region ${LOCATION}"
    fi

    if $INTERNAL ;then
        CMD+=" --internal-ip"
    fi

    $CMD

    "$@"
fi
