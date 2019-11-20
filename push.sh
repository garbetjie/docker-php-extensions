#!/usr/bin/env bash

project="$1"
docker_hub_repo="$2"

# Ensure we have a project id.
if [[ "$#" -lt 2 ]]; then
    printf "Usage: %s \e[4mGCP_PROJECT\e[0m \e[4mDOCKER_HUB_REPO\e[0m\n" "$0"
    exit 1
fi

# Change into this directory.
cd "$(cd "$(dirname "$0")" && pwd)"

# Submit the build.
printf "\n\e[38;5;116mSubmitting build.\e[0m\n"
gcloud builds submit \
    --project "$project" \
    --machine-type n1-highcpu-32 \
    --substitutions "_DOCKER_HUB_REPO=${docker_hub_repo}" \
    --config ./cloudbuild.yaml .
