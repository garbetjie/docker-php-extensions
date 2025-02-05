ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

# Unpack source
RUN docker-php-source extract

# Download
RUN apk add --no-cache libssh2-dev
RUN mkdir /usr/src/php/ext/ssh2
RUN wget -O- https://pecl.php.net/get/ssh2-1.4.1.tgz | tar -C /usr/src/php/ext/ssh2 -xzf - --strip-components 1

# Install
RUN docker-php-ext-install ssh2

# Package
COPY apk /docker-php-extensions/apk/ssh2
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/ssh2.so \
      $(php-config --ini-dir)/docker-php-ext-ssh2.ini \
      /docker-php-extensions


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
