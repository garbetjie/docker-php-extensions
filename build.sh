#!/usr/bin/env bash

set -e -o pipefail

docker build --build-arg PHP_VERSION=8.0.8 -t build/php:"$1" -f extensions/$1/Dockerfile --progress plain extensions/$1

echo ""
echo "-----------------------------------------"
echo "Image list:"
echo "-----------------------------------------"
docker images --filter reference=build/php:"$1"

cat <<EOT | docker build -t build/php:testing --progress plain - &> /dev/null
FROM php:8.0.8-cli-alpine3.14
COPY --from=build/php:$1 / /
COPY --from=build/php:builder / /
RUN docker-php-install-dependencies.sh
EOT

start_size="$(docker image inspect php:8.0.8-cli-alpine3.14 | jq -r '.[0].Size')"
end_size="$(docker image inspect build/php:testing | jq -r '.[0].Size')"
echo "Final layer size: $(echo "scale=1; ($end_size - $start_size)" | bc | numfmt --to=iec --round=nearest)"

echo ""
echo "-----------------------------------------"
echo "Module listing:"
echo "-----------------------------------------"
docker run --rm build/php:testing php -m
