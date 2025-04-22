ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/amqp
RUN curl https://pecl.php.net/get/amqp-2.1.2.tgz | tar -C /usr/src/php/ext/amqp -xzf - --strip-components 1

# Install
RUN apt-get update
RUN apt-get install -y librabbitmq-dev libssh-dev
RUN docker-php-ext-configure amqp
RUN docker-php-ext-install amqp

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/amqp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/amqp.so \
      $(php-config --ini-dir)/docker-php-ext-amqp.ini \
      /opt/docker-php-extensions


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
