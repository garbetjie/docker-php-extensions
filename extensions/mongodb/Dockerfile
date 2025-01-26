ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/mongodb
RUN curl https://pecl.php.net/get/mongodb-1.19.4.tgz | tar -C /usr/src/php/ext/mongodb -xzf - --strip-components 1

# Install
RUN docker-php-ext-configure mongodb
RUN docker-php-ext-install mongodb

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/mongodb.so \
      $(php-config --ini-dir)/docker-php-ext-mongodb.ini


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
