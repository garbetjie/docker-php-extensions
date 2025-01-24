ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/imagick
RUN curl https://pecl.php.net/get/imagick-3.7.0.tgz | tar -C /usr/src/php/ext/imagick -xzf - --strip-components 1

# Install
RUN apt update
RUN apt install -y libmagick++-dev
RUN docker-php-ext-install imagick

# Package
COPY apt /opt/docker-php-extensions/apt/imagick
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/imagick.so \
      $(php-config --ini-dir)/docker-php-ext-imagick.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
