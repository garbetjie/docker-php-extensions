ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Install
RUN docker-php-ext-install exif

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/exif.so \
      $(php-config --ini-dir)/docker-php-ext-exif.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
