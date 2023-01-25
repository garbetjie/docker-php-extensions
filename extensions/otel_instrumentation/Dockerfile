ARG PHP_VERSION
FROM php:${PHP_VERSION}-cli-alpine3.16

# Unpack source
RUN docker-php-source extract

# Download
RUN mkdir /usr/src/php/ext/otel_instrumentation
RUN apk add git
RUN git clone https://github.com/open-telemetry/opentelemetry-php-instrumentation.git /usr/src/php/ext/otel_instrumentation

# Install
RUN docker-php-ext-install otel_instrumentation

## Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/otel_instrumentation.so \
      $(php-config --ini-dir)/docker-php-ext-otel_instrumentation.ini


FROM php:${PHP_VERSION}-cli-alpine3.16

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
