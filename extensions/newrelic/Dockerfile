ARG SOURCE_IMAGE="php"
ARG PHP_VERSION="8.4"
ARG NEWRELIC_VERSION="11.6.0.19"
FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

WORKDIR /tmp/newrelic

RUN curl https://download.newrelic.com/php_agent/archive/11.6.0.19/newrelic-php5-11.6.0.19-linux.tar.gz | tar -xzf - --strip-components 1

RUN set -e; \
    if [ "$(uname -m)" = "x86_64" ]; then arch="x64"; else arch="aarch64"; fi; \
    extension_version="$(basename "$(php-config --extension-dir)" | tr -cd '[:digit:]')"; \
    cp agent/$arch/newrelic-$extension_version.so $(php-config --extension-dir)/newrelic.so; \
    cp scripts/newrelic.ini.template $(php-config --ini-dir)/docker-php-ext-newrelic.ini; \
    cp daemon/newrelic-daemon.$arch /usr/bin/newrelic-daemon; \
    mkdir /var/log/newrelic

# Package
COPY install.sh /usr/local/bin/docker-php-install-ext-deps.sh
COPY apt /opt/docker-php-extensions/apt/newrelic
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/newrelic.so \
      $(php-config --ini-dir)/docker-php-ext-newrelic.ini \
      /opt/docker-php-extensions \
      /usr/bin/newrelic-daemon \
      /var/log/newrelic


FROM ${SOURCE_IMAGE}:${PHP_VERSION}-cli-bookworm

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /

