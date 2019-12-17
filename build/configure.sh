#!/usr/bin/env sh

set -ex -o pipefail

if test "$PHP_VERSION" = "7.4"; then
  ext_zip_options=""
  ext_gd_options="--with-jpeg --with-webp"
else
  ext_zip_options="--with-libzip"
  ext_gd_options="--with-jpeg-dir=/usr/lib --with-webp-dir=/usr/lib"
fi

# shellcheck disable=SC2086
docker-php-ext-configure zip $ext_zip_options
# shellcheck disable=SC2086
docker-php-ext-configure gd $ext_gd_options
