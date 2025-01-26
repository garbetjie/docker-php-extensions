ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/apcu
RUN curl https://pecl.php.net/get/apcu-5.1.24.tgz | tar -C /usr/src/php/ext/apcu -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure apcu
RUN docker-php-ext-install apcu

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/apcu.so \
      $(php-config --ini-dir)/docker-php-ext-apcu.ini


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
