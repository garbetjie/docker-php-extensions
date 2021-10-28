#!/usr/bin/env bash

variants=("fpm" "nginx" "cli")
versions=("7.3" "7.4" "8.0")
root_dir="$(printf "%s" "$(cd "$(dirname "$0")" || exit; pwd -P)")"

set -e

trap exit SIGINT

for variant in "${variants[@]}"; do
  for version in "${versions[@]}"; do
    "$root_dir/run-tests.sh" "$version" "$variant"
  done
done
