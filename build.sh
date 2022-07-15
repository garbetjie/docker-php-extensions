#!/usr/bin/env bash

set -e -o pipefail

docker build --build-arg PHP_VERSION=8.0.8 -t build/php:"$1" -f ext/$1/Dockerfile --progress plain ext/$1

docker images | grep -F build/php