ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

# Install
RUN docker-php-ext-configure bcmath
RUN docker-php-ext-install bcmath

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/bcmath.so \
      $(php-config --ini-dir)/docker-php-ext-bcmath.ini


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root

# Debugging of arch.
RUN file /tmp/root$(php-config --extension-dir)/bcmath.so


FROM scratch

COPY --from=1 /tmp/root /
