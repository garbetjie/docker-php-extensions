ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/sqlsrv
RUN curl https://pecl.php.net/get/sqlsrv-5.12.0.tgz | tar -C /usr/src/php/ext/sqlsrv -xzf - --strip-components 1

# Install
RUN apt update
RUN apt install -y unixodbc-dev gnupg
RUN docker-php-ext-install sqlsrv

# Package
COPY apt /opt/docker-php-extensions/apt/sqlsrv
COPY shell /opt/docker-php-extensions/shell/sqlsrv
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/sqlsrv.so \
      $(php-config --ini-dir)/docker-php-ext-sqlsrv.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
