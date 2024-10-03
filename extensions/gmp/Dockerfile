ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN apt-get update
RUN apt-get install -y libgmp-dev
RUN docker-php-ext-install gmp

# Package
COPY apt /pkgs/apt/gmp
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gmp.so \
      $(php-config --ini-dir)/docker-php-ext-gmp.ini \
      /pkgs


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
