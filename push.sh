#!/usr/bin/env bash

project="$1"
docker_hub_repo="$2"
tag="$(date "+%Y%m%d")"

# Ensure we have a project id.
if [[ "$#" -lt 2 ]]; then
    echo "Usage: GOOGLE_PROJECT_ID DOCKER_HUB_REPO"
    exit 1
fi

# Change into this directory.
cd "$(cd "$(dirname "$0")" && pwd)"

# Update the tags.
printf "Do you want to create a date-stamped tag? [Y/n]? "
read confirm

if [[ "$confirm" = "Y" ]] || [[ "$confirm" = "y" ]] || [[ "$confirm" = "" ]]; then
    printf "\n"
    printf "\e[38;5;116mRecreating tag on remote (may show errors if remote tag doesn't exist)\e[0m\n"
    git tag -d "$tag"
    git push origin :"$tag"
    git tag -am "Release: $tag" "$tag"
    git push origin "$tag"
fi

# Submit the build.
printf "\n\e[38;5;116mSubmitting build.\e[0m\n"
gcloud builds submit \
    --project "$project" \
    --substitutions "_DOCKER_HUB_REPO=${docker_hub_repo}" \
    --config ./cloudbuild.yaml .
