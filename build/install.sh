#!/usr/bin/env sh

set -ex -o pipefail

docker-php-ext-install -j5 \
  bcmath \
  bz2 \
  exif \
  gd \
  gettext \
  gmp \
  imap \
  intl \
  opcache \
  pcntl \
  pdo_mysql \
  soap \
  sockets \
  zip

pecl install \
  amqp \
  igbinary \
  memcached \
  msgpack \
  redis \
  xdebug-2.8.0

if test "$ZTS_ENABLED" = true; then
  pecl install parallel
fi

if test "$PHP_VERSION" = "7.4"; then
  opencensus_src_url="https://github.com/garbetjie/opencensus-php/archive/failing-tests-7.4.tar.gz"
else
  opencensus_src_url="https://github.com/census-instrumentation/opencensus-php/archive/d1512abf456761165419a7b236e046a38b61219e.tar.gz"
fi

# Install OpenCensus.
wget "$opencensus_src_url" -O- | tar -C /tmp -xzf -
cd /tmp/opencensus-php-*/ext
phpize
./configure --enable-opencensus
make
echo 'n' | make test
make install

# Install New Relic.
wget https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/newrelic-php5-${NEWRELIC_VERSION}-linux-musl.tar.gz -O- | tar -xz -C /tmp
mv /tmp/newrelic-php5-*${NEWRELIC_VERSION}-linux-musl /opt/newrelic
find /opt/newrelic/agent/x64 -type f ! -name "newrelic-$(php -n -i | grep -F 'PHP Extension =' | sed -e 's/PHP Extension => //')$(if [ $ZTS_ENABLED = true ]; then printf -- '-zts'; else printf ''; fi).so" -delete
mv "$(find /opt/newrelic/agent/x64 -iname '*.so' | head -n 1)" $(php -n -r 'echo ini_get("extension_dir");')/newrelic.so
mv /opt/newrelic/daemon/newrelic-daemon.x64 /opt/newrelic/daemon.x64
rm -rf /opt/newrelic/daemon /opt/newrelic/agent/ /opt/newrelic/scripts

# Enable extensions not installed through `docker-php-ext-install`.
docker-php-ext-enable \
  amqp \
  igbinary \
  memcached \
  msgpack \
  newrelic \
  opencensus \
  redis \
  xdebug

# Enable the parallel extension if installed.
if [ "$ZTS_ENABLED" = true ]; then
  docker-php-ext-enable parallel
fi
