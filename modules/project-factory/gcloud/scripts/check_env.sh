#!/bin/sh

set -e

SKIP=${GCLOUD_TF_DOWNLOAD}

echo "{\"download\": \"${SKIP}\"}"
