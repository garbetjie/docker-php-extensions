#!/usr/bin/env sh
set -e

# Remove NewRelic configuration file if not enabled.
if [ "$NEWRELIC_ENABLED" != "true" ]; then
    rm -f "${PHP_INI_DIR}/conf.d/docker-php-ext-newrelic.ini"
fi

# Remove XDebug configuration if not enabled.
if [ "$XDEBUG_ENABLED" != "true" ]; then
    rm -f "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini"
fi

# Function used to compare version numbers.
version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

#
# Update FPM configuration.
#

if [ "$MAX_CHILDREN" -lt 1 ]; then
    # See https://github.com/moby/moby/issues/20688#issuecomment-188923858 for why we check memory.limit_in_bytes first.
    # Need to convert it from bytes to KB though.
    cgroups_mem="$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)"
    meminfo_mem="$(($(grep MemTotal /proc/meminfo | awk '{print $2}') * 1024))"

    # See https://github.com/carlossg/openjdk/blob/e8bfbbc39ef4aea0fcf07ad6dc43bd11993d3f5b/docker-jvm-opts.sh for the
    # logic of comparing cgroup memory and meminfo memory.
    if [ "$meminfo_mem" -gt "$cgroups_mem" ]; then
        available_mem="$cgroups_mem"
    else
        available_mem="$meminfo_mem"
    fi

    # Convert B down to MB.
    available_mem="$(expr "$available_mem" "/" 1024 "/" 1024)"
    clean_memory_limit="$(echo "$MEMORY_LIMIT" | grep -oE '[0-9]+')"
    export MAX_CHILDREN="$((available_mem * 90 / 100 / clean_memory_limit))"
fi

# Ensure we always have at least one child.
if [ "$MAX_CHILDREN" -lt 1 ]; then
    export MAX_CHILDREN=1
fi

# Substitute values in the php-fpm file.
# shellcheck disable=SC2016
envsubst '$PM
          $MAX_CHILDREN
          $MIN_SPARE_SERVERS
          $MAX_SPARE_SERVERS
          $MAX_REQUESTS
          $STATUS_PATH
          $TIMEOUT' < /usr/local/etc/php-fpm.conf > /usr/local/etc/php-fpm.conf.tmp

mv /usr/local/etc/php-fpm.conf.tmp /usr/local/etc/php-fpm.conf

# Comment out configuration that isn't available in 7.2
if [ "$(version "$PHP_VERSION")" -lt "$(version 7.3.0)" ]; then
    sed -i 's/^decorate_workers_output/\;decorate_workers_output/;s/^log_limit/\;log_limit/' /usr/local/etc/php-fpm.conf
fi

# Substitute values in the PHP ini files.
for src_file in "$PHP_INI_DIR"/**/*.ini "$PHP_INI_DIR"/*.ini /opt/newrelic/newrelic.cfg; do
    temporary_file="${src_file}.tmp"

    # shellcheck disable=SC2016
    envsubst '$DISPLAY_ERRORS
              $ERROR_REPORTING
              $HTML_ERRORS
              $MAX_EXECUTION_TIME
              $MAX_INPUT_TIME
              $MAX_REQUEST_SIZE
              $MEMORY_LIMIT
              $NEWRELIC_APP_NAME
              $NEWRELIC_AUTORUM_ENABLED
              $NEWRELIC_DAEMON_LOGLEVEL
              $NEWRELIC_DAEMON_PORT
              $NEWRELIC_HOST_DISPLAY_NAME
              $NEWRELIC_LABELS
              $NEWRELIC_LICENCE
              $NEWRELIC_RECORD_SQL
              $SESSION_SAVE_HANDLER
              $SESSION_SAVE_PATH
              $TIMEZONE
              $UPLOAD_MAX_FILESIZE
              $XDEBUG_ENABLED
              $XDEBUG_IDE_KEY
              $XDEBUG_REMOTE_AUTOSTART
              $XDEBUG_REMOTE_HOST
              $XDEBUG_REMOTE_PORT' < "$src_file" > "$temporary_file"

    mv "$temporary_file" "$src_file"
done

# Start the daemon, before executing the main script.
/usr/local/bin/start-newrelic-daemon.sh || true

# Attempt to find the FPM binary.
FPM_BINARY="$(command -v php-fpm || true)"

# Only attempt to execute FPM if it is available.
if [ "$FPM_BINARY" != "" ]; then
  if [ $# -lt 1 ]; then
      exec php-fpm
  else
      exec "$@"
  fi

# Executing the CLI image.
else
  if [ "${1#-}" != "$1" ]; then
    set -- php "$@"
  fi
  exec "$@"
fi
