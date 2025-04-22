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
ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM \${SOURCE_IMAGE}:\${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/${1}
RUN curl https://pecl.php.net/get/${1}-VERSION.tgz | tar -C /usr/src/php/ext/${1} -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y PACKAGES_TO_INSTALL
RUN docker-php-ext-configure $1
RUN docker-php-ext-install $1

# Package
COPY install.sh /usr/local/bin/docker-php-ext-install-deps
COPY apt /opt/docker-php-extensions/apt/$1
COPY shell /opt/docker-php-extensions/shell/$1
RUN tar -cf /tmp/files.tar \\
      \$(php-config --extension-dir)/$1.so \\
      \$(php-config --ini-dir)/docker-php-ext-$1.ini \\
      /opt/docker-php-extensions


FROM \${SOURCE_IMAGE}:\${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
EOT

# Create file system

# Copy install script.
cp install-dependencies.sh "extensions/$1/install.sh"

# Make package dependency file.
touch "extensions/$1/apt"

# Make shell dependency file.
cat <<EOT > "extensions/$1/shell"
#!/usr/bin/env sh

exit 0
EOT
