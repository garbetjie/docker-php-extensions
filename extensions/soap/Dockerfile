ARG PHP_VERSION="8.4"
FROM php:${PHP_VERSION}-cli-bookworm

# Install
RUN apt-get update
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/soap.so \
      $(php-config --ini-dir)/docker-php-ext-soap.ini


FROM php:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
