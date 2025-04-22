ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Install
RUN apt-get update
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
RUN tar -cf /tmp/files.tar \
      /usr/local/bin/docker-php-install-ext-deps.sh \
      $(php-config --extension-dir)/soap.so \
      $(php-config --ini-dir)/docker-php-ext-soap.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
