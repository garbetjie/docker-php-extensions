#!/usr/bin/env bash

announce() {
  printf "%$((${#1} + 12))s\n" "" | sed 's/ /#/g'
  printf "###   %${#1}s   ###\n" " "
  echo   "###   ${1}   ###"
  printf "###   %${#1}s   ###\n" " "
  printf "%$((${#1} + 12))s\n" "" | sed 's/ /#/g'
}

trap exit SIGINT

announce "7.3-nginx"
docker build -t build/garbetjie/php:7.3-nginx --cache-from garbetjie/php:7.3-nginx --build-arg SOURCE_IMAGE=php:7.3.29-fpm-alpine3.14 -f Dockerfile --target nginx .
announce "7.3-fpm"
docker build -t build/garbetjie/php:7.3-fpm --cache-from garbetjie/php:7.3-fpm --build-arg SOURCE_IMAGE=php:7.3.29-fpm-alpine3.14 -f Dockerfile --target variant .
announce "7.3-cli"
docker build -t build/garbetjie/php:7.3-cli --cache-from garbetjie/php:7.3-cli --build-arg SOURCE_IMAGE=php:7.3.29-cli-alpine3.14 -f Dockerfile --target variant .

announce "7.4-cli"
docker build -t build/garbetjie/php:7.4-nginx --cache-from garbetjie/php:7.4-nginx --build-arg SOURCE_IMAGE=php:7.4.21-fpm-alpine3.14 -f Dockerfile --target nginx .
announce "7.4-cli"
docker build -t build/garbetjie/php:7.4-fpm --cache-from garbetjie/php:7.4-fpm --build-arg SOURCE_IMAGE=php:7.4.21-fpm-alpine3.14 -f Dockerfile --target variant .
announce "7.4-cli"
docker build -t build/garbetjie/php:7.4-cli --cache-from garbetjie/php:7.4-cli --build-arg SOURCE_IMAGE=php:7.4.21-cli-alpine3.14 -f Dockerfile --target variant .

announce "8.0-cli"
docker build -t build/garbetjie/php:8.0-nginx --cache-from garbetjie/php:8.0-nginx --build-arg SOURCE_IMAGE=php:8.0.8-fpm-alpine3.14 -f Dockerfile --target nginx .
announce "8.0-cli"
docker build -t build/garbetjie/php:8.0-fpm --cache-from garbetjie/php:8.0-fpm --build-arg SOURCE_IMAGE=php:8.0.8-fpm-alpine3.14 -f Dockerfile --target variant .
announce "8.0-cli"
docker build -t build/garbetjie/php:8.0-cli --cache-from garbetjie/php:8.0-cli --build-arg SOURCE_IMAGE=php:8.0.8-cli-alpine3.14 -f Dockerfile --target variant .