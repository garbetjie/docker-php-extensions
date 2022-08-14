ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.14

# Unpack PHP source
RUN docker-php-source extract

# Install extension.
RUN apk add gd-dev libpng-dev libwebp-dev libjpeg-turbo-dev libxpm-dev
RUN docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-xpm --with-freetype
RUN docker-php-ext-install gd

# Package extension.
COPY apk /tmp/docker-php-dependencies.d/apk/gd
RUN tar -cf /tmp/files.tar \
      /tmp/docker-php-dependencies.d \
      /usr/local/etc/php/conf.d/docker-php-ext-gd.ini \
      /usr/local/lib/php/extensions/*-zts-*/gd.so


FROM php:${PHP_VERSION}-cli-alpine3.14

# Copy in tar file.
COPY --from=0 /tmp/files.tar /tmp/

# Extract tar file into it's own directory.
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

# Copy in only the files required for the extension.
COPY --from=1 /tmp/root /

