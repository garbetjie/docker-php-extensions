ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/yaml
RUN curl https://pecl.php.net/get/yaml-2.2.3.tgz | tar -C /usr/src/php/ext/yaml -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y libyaml-dev

RUN docker-php-ext-configure yaml
RUN docker-php-ext-install yaml

# Package
COPY apt /opt/docker-php-extensions/apt/yaml
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/yaml.so \
      $(php-config --ini-dir)/docker-php-ext-yaml.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
