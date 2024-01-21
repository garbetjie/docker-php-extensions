#!/usr/bin/env sh

set -xe

# Install APK dependencies.
if [ -d /docker-php-extensions/dependencies/apk ]; then
  echo "### Installing APK dependencies..."
  awk '{ print $0 }' /docker-php-extensions/dependencies/apk/* | tr '\n' ' ' | xargs apk add --no-cache
fi

# Run custom setup scripts.
if [ -d /docker-php-extensions/dependencies/shell ]; then
  for filename in /docker-php-extensions/dependencies/shell/*; do
    echo "### Executing extension setup script [$(basename "$filename")]..."
    sh "$filename"
  done
fi

# Clean up.
rm -rf /docker-php-extensions
