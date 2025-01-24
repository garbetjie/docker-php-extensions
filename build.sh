#!/usr/bin/env bash

set -e -o pipefail

platform=""
ext="$1"
php_version="8.1"
tag_suffix="-cli-bookworm"
alpine_version="3.19"

while [ $# -gt 0 ]; do
  case "$1" in
    --x86) platform="--platform linux/amd64"; shift;;
    --arm) platform="--platform linux/arm64"; shift;;
    --php-version) php_version="$2"; shift 2;;
    *) ext="$1"; shift;;
  esac
done

image_tag="$php_version$tag_suffix"
set -x
docker build \
  -t build/php:"$ext" \
  --build-arg "IMAGE_TAG=$image_tag" \
  $platform \
  -f extensions/$ext/Dockerfile \
  --progress plain \
  extensions/$ext
set +x
echo ""
echo "-----------------------------------------"
echo "Image list:"
echo "-----------------------------------------"
docker images --filter reference=build/php:"$ext"

cat <<EOT | docker build -t build/php:testing $platform --progress plain -
FROM php:$image_tag
COPY --from=build/php:$ext / /
RUN apt update && \
    if [ -d /opt/docker-php-extensions/apt ]; then awk '{ print \$0 }' /pkgs/apt/* | tr '\n' ' ' | xargs apt install -y; fi && \
    { \
      if [ -d /opt/docker-php-extensions/shell ]; then \
        for filename in /opt/docker-php-extensions/shell/*; do \
          echo "### Executing extension setup script [$(basename "\$filename")]..." && \
          bash "\$filename"; \
        done \
      fi \
    } && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
EOT

start_size="$(docker image inspect php:$image_tag | jq -r '.[0].Size')"
end_size="$(docker image inspect build/php:testing | jq -r '.[0].Size')"
echo "Final layer size: $(echo "scale=1; ($end_size - $start_size)" | bc | numfmt --to=iec --round=nearest)"

echo ""
echo "-----------------------------------------"
echo "Module listing:"
echo "-----------------------------------------"
docker run --rm $platform build/php:testing php -m

echo "Extension loaded?"

docker run --rm $platform build/php:testing php -r 'echo extension_loaded("'"$ext"'") ? "Yes\n" : "No\n";'