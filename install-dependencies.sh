#!/usr/bin/env sh

set -xe

# Install APK dependencies.
if [ -d /docker-php-extensions/apk ]; then
  echo "### Installing APK dependencies..."
  awk '{ print $0 }' /docker-php-extensions/apk/* | tr '\n' ' ' | xargs apk add --no-cache
fi

if [ -d /tmp/docker-php-dependencies.d/apk ]; then
  echo "### Installing APK dependencies..."
  awk '{ print $0 }' /tmp/docker-php-dependencies.d/apk/* | tr '\n' ' ' | xargs apk add --no-cache
fi

# Run custom setup scripts.
if [ -d /docker-php-extensions/shell ]; then
  for filename in /docker-php-extensions/shell/*; do
    echo "### Executing extension setup script [$(basename "$filename")]..."
    sh "$filename"
  done
fi

if [ -d /tmp/docker-php-dependencies.d/shell ]; then
  for filename in /tmp/docker-php-dependencies.d/shell/*; do
    echo "### Executing extension setup script [$(basename "$filename")]..."
    sh "$filename"
  done
fi

# Clean up.
rm -rf /docker-php-extensions /tmp/docker-php-dependencies.d
