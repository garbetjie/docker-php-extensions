ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN docker-php-ext-install pcntl

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pcntl.so \
      $(php-config --ini-dir)/docker-php-ext-pcntl.ini


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
