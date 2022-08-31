#!/usr/bin/env sh

set -xe

# Copying the extension layers causes permissions to be lost. We'll need to fix this.
chmod 1777 /tmp

# Install APK dependencies.
if [ -d /tmp/docker-php-dependencies.d/apk ]; then
  echo "### Installing APK dependencies..."
  awk '{ print $0}' /tmp/docker-php-dependencies.d/apk/* | tr '\n' ' ' | xargs apk add --no-cache
fi

# Run custom setup scripts.
if [ -d /tmp/docker-php-dependencies.d/shell ]; then
  for filename in /tmp/docker-php-dependencies.d/shell/*; do
    echo "### Executing extension setup script [$(basename "$filename")]..."
    sh "$filename"
  done
fi

# Clean up.
rm -rf /tmp/docker-php-dependencies.d
