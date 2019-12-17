#!/usr/bin/env sh

set -ex -o pipefail

rm -rf /tmp/pear* /tmp/opencensus*
apk del --purge .build-deps

docker-php-source delete
