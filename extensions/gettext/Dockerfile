ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN apt-get update
RUN apt-get install -y gettext
RUN docker-php-ext-install gettext

# Package
COPY apt /opt/docker-php-extensions/apt/gettext
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gettext.so \
      $(php-config --ini-dir)/docker-php-ext-gettext.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
