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
ARG IMAGE_TAG="8.4-cli-bookworm"
FROM php:\$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/${1}
RUN curl https://pecl.php.net/get/${1}-VERSION.tgz | tar -C /usr/src/php/ext/${1} -xzf - --strip-components 1

# Install
# RUN apt update
# RUN apt install -y PACKAGES_TO_INSTALL
RUN docker-php-ext-configure $1
RUN docker-php-ext-install $1

# Package
COPY apt /opt/docker-php-extensions/apt/$1
COPY shell /opt/docker-php-extensions/shell/$1
RUN tar -cf /tmp/files.tar \\
      \$(php-config --extension-dir)/$1.so \\
      \$(php-config --ini-dir)/docker-php-ext-$1.ini \\
      /opt/docker-php-extensions


FROM php:\$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
EOT

# Create file system

# Make package dependency file.
touch "extensions/$1/apt"

# Make shell dependency file.
cat <<EOT > "extensions/$1/shell"
#!/usr/bin/env sh

exit 0
EOT
