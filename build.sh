#!/usr/bin/env bash

set -e -o pipefail

ext="$1"
php_version="8.1"
tag_suffix="-cli-bookworm"
skip_cache=""

while [ $# -gt 0 ]; do
  case "$1" in
    --no-cache) skip_cache="--no-cache"; shift;;

    --php-version) php_version="$2"; shift 2;;
    *) ext="$1"; shift;;
  esac
done

image_tag="$php_version$tag_suffix"
set -x
docker build \
  -t build/php:"$ext" \
  --platform linux/arm64,linux/amd64 \
  --build-arg "PHP_VERSION=$php_version" \
  $skip_cache \
  -f extensions/$ext/Dockerfile \
  --progress plain \
  extensions/$ext

set +x
echo ""
echo "-----------------------------------------"
echo "Image list:"
echo "-----------------------------------------"
docker images --filter reference=build/php:"$ext"

cat <<EOT | docker build $skip_cache -t build/php:testing --progress plain -
FROM php:$image_tag
COPY --from=build/php:$ext / /
RUN curl https://raw.githubusercontent.com/garbetjie/docker-php-extensions/refs/heads/main/install-dependencies.sh | sh
EOT

start_size="$(docker image inspect php:$image_tag | jq -r '.[0].Size')"
end_size="$(docker image inspect build/php:testing | jq -r '.[0].Size')"
echo "Final layer size: $(echo "scale=1; ($end_size - $start_size)" | bc | numfmt --to=iec --round=nearest)"

echo ""
echo "-----------------------------------------"
echo "Module listing:"
echo "-----------------------------------------"
docker run --rm build/php:testing php -m

echo "Extension loaded?"

docker run --rm build/php:testing php -r 'echo extension_loaded("'"$ext"'") ? "Yes\n" : "No\n";'