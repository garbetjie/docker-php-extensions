#!/usr/bin/env sh
set -xe
# No directory.
if [ ! -d /tmp/docker-php-dependencies.d ]; then
  exit 0
fi

# Install dependencies.
cat /tmp/docker-php-dependencies.d/* | tr '\n' ' ' | xargs apk add --no-cache

# Remove dependency directory.
rm -rf /tmp/docker-php-dependencies.d