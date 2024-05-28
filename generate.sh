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
ARG ALPINE_VERSION=3.18
FROM php:\${PHP_VERSION}-cli-alpine\${ALPINE_VERSION}

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/${1}
RUN wget -O- https://pecl.php.net/get/${1}-VERSION.tgz | tar -C /usr/src/php/ext/${1} -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure $1
RUN docker-php-ext-install $1

# Package
COPY apk /docker-php-extensions/apk/$1
COPY shell /docker-php-extensions/shell/$1
RUN tar -cf /tmp/files.tar \\
      \$(php-config --extension-dir)/$1.so \\
      \$(php-config --ini-dir)/docker-php-ext-$1.ini \\
      /docker-php-extensions


FROM php:\${PHP_VERSION}-cli-alpine\${ALPINE_VERSION}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
EOT

# Create file system

# Make APK dependency file.
touch "extensions/$1/apk"

# Make shell dependency file.
cat <<EOT > "extensions/$1/shell"
#!/usr/bin/env sh

exit 0
EOT
