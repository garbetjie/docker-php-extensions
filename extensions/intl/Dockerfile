ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

# Install
RUN apk add icu-dev
RUN docker-php-ext-install intl

# Package
COPY apk /opt/docker-php-extensions/apk/intl
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/intl.so \
      $(php-config --ini-dir)/docker-php-ext-intl.ini \
      /opt/docker-php-extensions


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
