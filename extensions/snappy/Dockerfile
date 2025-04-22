ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Unpack source
RUN docker-php-source extract

# Download
RUN apt-get update
RUN apt-get install -y git
RUN git clone --recursive --depth=1 https://github.com/kjdev/php-ext-snappy.git /usr/src/php/ext/snappy

# Install
RUN docker-php-ext-configure snappy
RUN docker-php-ext-install snappy

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/snappy
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/snappy.so \
      $(php-config --ini-dir)/docker-php-ext-snappy.ini \
      /opt/docker-php-extensions

RUN ls -lah $(php-config --extension-dir)
RUN ls -lah $(php-config --ini-dir)

FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
