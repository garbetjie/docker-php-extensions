ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN apt-get update
RUN apt-get install -y libgd-dev libpng-dev libwebp-dev libjpeg62-turbo-dev libxpm-dev
RUN docker-php-ext-configure gd --enable-gd --with-webp --with-jpeg --with-xpm --with-freetype
RUN docker-php-ext-install gd

# Package
COPY apt /opt/docker-php-extensions/apt/gd
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/gd.so \
      $(php-config --ini-dir)/docker-php-ext-gd.ini \
      /opt/docker-php-extensions


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
