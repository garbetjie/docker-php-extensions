#!/usr/bin/env bash

set -e -o pipefail

docker build --build-arg PHP_VERSION=8.0.8 -t build/php:"$1" -f extensions/$1/Dockerfile --progress plain extensions/$1

echo ""
echo "-----------------------------------------"
echo "Image list:"
echo "-----------------------------------------"
docker images | grep -F "build/php" | grep -F "$1"

echo ""
echo "-----------------------------------------"
echo "Module listing:"
echo "-----------------------------------------"
cat <<EOT | docker build -t build/php:testing --progress plain - &> /dev/null
FROM php:8.0.8-cli-alpine3.14
COPY --from=build/php:$1 / /
COPY --from=build/php:builder / /
RUN docker-php-install-dependencies.sh
EOT
docker run --rm build/php:testing php -m
