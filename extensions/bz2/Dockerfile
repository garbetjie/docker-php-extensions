ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Install
RUN apt-get update
RUN apt-get install -y libbz2-dev
RUN docker-php-ext-install bz2

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/bz2
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/bz2.so \
      $(php-config --ini-dir)/docker-php-ext-bz2.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
