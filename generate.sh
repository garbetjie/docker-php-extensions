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
FROM php:\${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/${1}
RUN wget -O- https://pecl.php.net/get/${1}-VERSION.tgz | tar -C /usr/src/php/ext/${1} -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure $1
RUN docker-php-ext-install $1

# Package
COPY apk /tmp/docker-php-dependencies.d/apk/$1
COPY shell /tmp/docker-php-dependencies.d/shell/$1
RUN tar -cf /tmp/files.tar \\
      \$(php-config --extension-dir)/$1.so \\
      \$(php-config --ini-dir)/docker-php-ext-$1.ini \\
      /tmp/docker-php-dependencies.d \\
      /etc/s6-overlay


FROM php:\${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root
RUN chmod 1777 /tmp/root/tmp


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

# Create service files.
mkdir -p "extensions/$1/services/config/contents.d"
touch    "extensions/$1/services/config/contents.d/config-ini-$1"

mkdir -p "extensions/$1/services/config-ini-$1"
echo "oneshot" > "extensions/$1/services/config-ini-$1/type"
echo "with-contenv sh /etc/s6-overlay/s6-rc.d/config-ini-$1/run" > "extensions/$1/services/config-ini-$1/up"

cat <<EOF > "extensions/$1/services/config-ini-$1/run"
#!/usr/bin/env sh

cat <<EOT > "\$(php-config --ini-dir)/zz-config-ini-$1.ini"
EOT
EOF