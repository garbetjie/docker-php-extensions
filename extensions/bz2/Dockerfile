ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN apt update
RUN apt install -y libbz2-dev
RUN docker-php-ext-install bz2

# Package
COPY apt /opt/docker-php-extensions/apt/bz2
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/bz2.so \
      $(php-config --ini-dir)/docker-php-ext-bz2.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
