#!/usr/bin/env bash

sed="$(command -v gsed)"

[[ "$sed" = "" ]] && sed="$(command -v sed)"
[[ "$sed" = "" ]] && { echo "sed is required."; exit 1; }

if ! command -v pup &> /dev/null; then
  echo "The pup command is required."
  exit 1
fi

for ext in amqp \
           apcu \
           ds \
           grpc \
           igbinary \
           imagick \
           memcached \
           memprof \
           mongodb \
           msgpack \
           pdo_sqlsrv \
           protobuf \
           redis \
           sqlsrv \
           ssh2 \
           swoole \
           uopz \
           xdebug \
           yaml
do
  echo -n "Fetching latest version for extension [$ext]... "

  version="$(curl -s "https://pecl.php.net/package/$ext" | pup 'table.middle td.content > table:nth-of-type(3) tr:nth-child(3) th:first-child a text{}')"

  "$sed" -i "s/https:\/\/pecl.php.net\/get\/$ext-\?.*.tgz/https:\/\/pecl.php.net\/get\/$ext-$version.tgz/" extensions/alpine/$ext/Dockerfile
  "$sed" -i "s/https:\/\/pecl.php.net\/get\/$ext-\?.*.tgz/https:\/\/pecl.php.net\/get\/$ext-$version.tgz/" extensions/debian/$ext/Dockerfile

  echo "$version [done]"
done