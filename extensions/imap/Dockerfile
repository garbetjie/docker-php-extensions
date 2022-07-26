ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Install extension.
RUN apk add krb5-dev imap-dev libretls-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap

# Package files for extension into tar file.
RUN mkdir /tmp/docker-php-dependencies.d

RUN echo c-client libssl1.1 > /tmp/docker-php-dependencies.d/imap
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-imap.ini \
      /usr/local/lib/php/extensions/*-zts-*/imap.so

FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

