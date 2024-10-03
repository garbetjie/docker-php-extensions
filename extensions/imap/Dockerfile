ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN apt-get update
RUN apt-get install -y libc-client2007e-dev libkrb5-dev libtls-dev
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap

# Package
COPY apt /pkgs/apt/imap
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/imap.so \
      $(php-config --ini-dir)/docker-php-ext-imap.ini \
      /pkgs


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
