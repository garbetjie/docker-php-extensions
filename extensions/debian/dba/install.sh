#!/usr/bin/env sh

set -xe

# Install packages.
if [ -d /opt/docker-php-extensions/apt ]; then
  echo "### Installing package dependencies..."

  apt-get update
  awk '{ print $0 }' /opt/docker-php-extensions/apt/* | tr '\n' ' ' | xargs apt-get install -y
fi

# Run custom shell scripts.
if [ -d /opt/docker-php-extensions/shell ]; then
  for filename in /opt/docker-php-extensions/shell/*; do
    echo "### Executing extension setup script [$(basename "$filename")]..."
    sh "$filename"
  done
fi

# Clean up.
rm -rf /opt/docker-php-extensions/