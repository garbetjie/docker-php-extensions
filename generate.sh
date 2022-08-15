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

# Unpack PHP source
RUN docker-php-source extract

# Download and unpack from PECL
RUN mkdir /usr/src/php/ext/${1}
RUN wget -O- https://pecl.php.net/get/${1}-VERSION.tgz | tar -C /usr/src/php/ext/${1} -xzf - --strip-components 1

# Install extension.
RUN docker-php-ext-configure $1
RUN docker-php-ext-install $1

# Package files for extension into tar file.
COPY apk /tmp/docker-php-dependencies.d/apk/$1
COPY shell /tmp/docker-php-dependencies.d/shell/$1

RUN tar -cf /tmp/files.tar \\
      /tmp/docker-php-dependencies.d \\
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

cat <<EOT > "extensions/$1/shell"
#!/usr/bin/env sh

exit 0
EOT

touch "extensions/$1/apk"