#!/usr/bin/env sh

set -ex -o pipefail

apk add --no-cache --virtual .build-deps \
    autoconf \
    build-base \
    bzip2-dev \
    gd-dev \
    gettext-dev \
    gmp-dev \
    icu-dev \
    imap-dev \
    libjpeg-turbo-dev \
    libmemcached-dev \
    libpng-dev \
    libwebp-dev \
    libxml2-dev \
    libzip-dev \
    rabbitmq-c-dev
