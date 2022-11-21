#!/usr/bin/env bash

set -e -o pipefail

platform=""
ext="$1"
php_version="8.0.22"

while [ $# -gt 0 ]; do
  case "$1" in
    --x86) platform="--platform linux/amd64"; shift;;
    --php-version) php_version="$2"; shift 2;;
    *) ext="$1"; shift;;
  esac
done

docker build --build-arg "PHP_VERSION=$php_version" $platform -t build/php:"$ext" -f extensions/$ext/Dockerfile --progress plain extensions/$ext

echo ""
echo "-----------------------------------------"
echo "Image list:"
echo "-----------------------------------------"
docker images --filter reference=build/php:"$ext"

cat <<EOT | docker build -t build/php:testing $platform --progress plain -
FROM php:$php_version-cli-alpine3.16
COPY --from=build/php:$ext / /
RUN wget -O- https://raw.githubusercontent.com/garbetjie/docker-php/main/install-dependencies.sh | sh
EOT

start_size="$(docker image inspect php:8.0.8-cli-alpine3.14 | jq -r '.[0].Size')"
end_size="$(docker image inspect build/php:testing | jq -r '.[0].Size')"
echo "Final layer size: $(echo "scale=1; ($end_size - $start_size)" | bc | numfmt --to=iec --round=nearest)"

echo ""
echo "-----------------------------------------"
echo "Module listing:"
echo "-----------------------------------------"
docker run --rm $platform build/php:testing php -m
