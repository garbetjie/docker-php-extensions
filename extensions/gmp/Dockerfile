ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

# Install
RUN apk add gmp-dev
RUN docker-php-ext-install gmp

# Package
COPY apk /docker-php-extensions/apk/gmp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gmp.so \
      $(php-config --ini-dir)/docker-php-ext-gmp.ini \
      /docker-php-extensions


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
