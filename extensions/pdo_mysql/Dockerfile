ARG IMAGE_TAG="8.3-cli-bookworm"
FROM php:$IMAGE_TAG

# Install
RUN docker-php-ext-configure pdo_mysql
RUN docker-php-ext-install pdo_mysql

# Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/pdo_mysql.so \
      $(php-config --ini-dir)/docker-php-ext-pdo_mysql.ini


FROM php:$IMAGE_TAG

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
