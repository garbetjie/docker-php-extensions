ARG IMAGE_TAG="8.4-cli-alpine"
FROM php:${IMAGE_TAG}

# Unpack source
RUN docker-php-source extract

# Download
RUN apk add git
RUN git clone https://github.com/open-telemetry/opentelemetry-php-instrumentation.git /usr/src/php/ext/opentelemetry.git
RUN mv /usr/src/php/ext/opentelemetry.git/ext /usr/src/php/ext/opentelemetry

# Install
RUN docker-php-ext-install opentelemetry

## Package
RUN tar -cf /tmp/files.tar \
      $(php-config --extension-dir)/opentelemetry.so \
      $(php-config --ini-dir)/docker-php-ext-opentelemetry.ini


FROM php:${IMAGE_TAG}

COPY --from=0 /tmp/files.tar /tmp/
RUN mkdir /tmp/root && tar -xf /tmp/files.tar -C /tmp/root


FROM scratch

COPY --from=1 /tmp/root /
