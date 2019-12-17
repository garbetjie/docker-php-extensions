#!/usr/bin/env sh

set -ex -o pipefail

export ZTS_ENABLED="$(php -ni 2>&1 | grep -qiF 'Thread Safety => enabled' && printf true || printf false)"
export ZTS_SUFFIX="$(if [ $ZTS_ENABLED = true ]; then printf '-zts'; else printf ''; fi)"
export PHP_VERSION="$(php -nv | grep -E -o 'PHP [0-9]+\.[0-9]+' | cut -f2 -d' ')"
export NEWRELIC_VERSION="9.4.1.250"
export OS="$(. /etc/os-release; printf "%s" "$ID")"

docker-php-source extract
