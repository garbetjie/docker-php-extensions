ARG PHP_VERSION=8.0.22

FROM alpine:3.16 AS fs

RUN mkdir /tmp/root
RUN wget https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-noarch.tar.xz -P /tmp
RUN wget https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-$(uname -m).tar.xz -P /tmp
RUN tar -C /tmp/root/ -Jxpf /tmp/s6-overlay-noarch.tar.xz
RUN tar -C /tmp/root/ -Jxpf /tmp/s6-overlay-$(uname -m).tar.xz
RUN mkdir /tmp/root/srv

COPY bin/ /tmp/root/usr/local/bin/

# Copy core services.
COPY services/config /tmp/root/etc/s6-overlay/s6-rc.d/config
COPY services/config-ini-core /tmp/root/etc/s6-overlay/s6-rc.d/config-ini-core
COPY services/user /tmp/root/etc/s6-overlay/s6-rc.d/user


FROM php:${PHP_VERSION}-cli-alpine3.16 AS cli

STOPSIGNAL SIGTERM

# Copy in base file system.
COPY --from=fs /tmp/root/ /

# Define PHP INI configuration.
ENV INI_EXPOSE_PHP="false" \
    INI_DISPLAY_ERRORS="false" \
    INI_DATE_TIMEZONE="" \
    INI_ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    INI_HTML_ERRORS="off" \
    INI_MAX_EXECUTION_TIME=30 \
    INI_MAX_INPUT_TIME=30 \
    INI_MAX_REQUEST_SIZE="8M" \
    INI_MEMORY_LIMIT="64M" \
    INI_POST_MAX_SIZE="8M" \
    INI_SESSION_NAME="session" \
    INI_SESSION_SAVE_HANDLER="files" \
    INI_SESSION_SAVE_PATH="/tmp/.php-sessions" \
    INI_SYS_TEMP_DIR="/tmp" \
    INI_UPLOAD_MAX_FILESIZE="8M"

ENTRYPOINT ["/init"]
CMD ["php", "-a"]


FROM php:${PHP_VERSION}-fpm-alpine3.16 AS www

STOPSIGNAL SIGTERM

# Copy in s6-overlay.
COPY --from=fs /tmp/root/ /

# Add nginx.
RUN apk add --no-cache nginx

# Add additional services.
COPY services/php-fpm /etc/s6-overlay/s6-rc.d/php-fpm
COPY services/nginx /etc/s6-overlay/s6-rc.d/nginx
RUN touch /etc/s6-overlay/s6-rc.d/user/contents.d/nginx /etc/s6-overlay/s6-rc.d/user/contents.d/php-fpm

# Define FPM configuration.
ENV FPM_LISTEN="" \
    FPM_PM="static" \
    FPM_PM_MAX_CHILDREN=0 \
    FPM_PM_MIN_SPARE_SERVERS=1 \
    FPM_PM_MAX_SPARE_SERVERS=3 \
    FPM_PM_MAX_REQUESTS=10000 \
    FPM_REQUEST_TERMINATE_TIMEOUT=60 \
    FPM_REQUEST_SLOWLOG_TIMEOUT=5 \
    FPM_SLOWLOG="/proc/self/fd/2"

# Define nginx configuration.
ENV NGINX_ABSOLUTE_REDIRECT="on" \
    NGINX_FASTCGI_BUFFER_SIZE="16k" \
    NGINX_FASTCGI_BUFFERING="on" \
    NGINX_FASTCGI_BUFFERS="16 16k" \
    NGINX_FASTCGI_BUSY_BUFFERS_SIZE="32k" \
    NGINX_LOG_FORMAT="main" \
    NGINX_PORT=80 \
    NGINX_PORT_IN_REDIRECT="on" \
    NGINX_ROOT="/srv"

# Define PHP INI configuration.
ENV INI_EXPOSE_PHP="false" \
    INI_DISPLAY_ERRORS="false" \
    INI_DATE_TIMEZONE="" \
    INI_ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    INI_HTML_ERRORS="off" \
    INI_MAX_EXECUTION_TIME=30 \
    INI_MAX_INPUT_TIME=30 \
    INI_MAX_REQUEST_SIZE="8M" \
    INI_MEMORY_LIMIT="64M" \
    INI_POST_MAX_SIZE="8M" \
    INI_SESSION_NAME="session" \
    INI_SESSION_SAVE_HANDLER="files" \
    INI_SESSION_SAVE_PATH="/tmp/.php-sessions" \
    INI_SYS_TEMP_DIR="/tmp" \
    INI_UPLOAD_MAX_FILESIZE="8M"

ENTRYPOINT ["/init"]