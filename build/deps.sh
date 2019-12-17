#!/usr/bin/env sh

set -ex -o pipefail

apk add --no-cache \
  c-client \
  gettext \
  gmp \
  icu-libs \
  libbz2 \
  libintl \
  libjpeg \
  libmemcached \
  libpng \
  libwebp \
  libzip \
  rabbitmq-c
