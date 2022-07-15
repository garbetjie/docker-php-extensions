#!/usr/bin/env bash


mkdir -p "extensions/$1"

if [ -f "extensions/$1/Dockerfile" ]; then
  read -rp "A Dockerfile for this extension already exists. Are you sure you want to overwrite it? [y/N]" result
  result="$(echo "$result" | tr '[:upper:]' '[:lower:]')"

  if [ "$result" != "y" ]; then
    echo "Skipping generation."
    exit 0
  fi
fi

cat <<EOT > "extensions/$1/Dockerfile"
ARG PHP_VERSION
FROM php:\${PHP_VERSION}-cli-alpine3.14

# Install extension.
RUN docker-php-ext-install $1

# Package files for extension into tar file.
RUN tar -cf /tmp/files.tar \\
      /usr/local/etc/php/conf.d/docker-php-ext-$1.ini \\
      /usr/local/lib/php/extensions/*-zts-*/$1.so

FROM php:\${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

EOT