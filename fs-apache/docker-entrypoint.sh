#!/usr/bin/env sh

set -e

if [ "$APACHE_START_SERVERS" -lt 1 ]; then
  # See https://github.com/moby/moby/issues/20688#issuecomment-188923858 for why we check memory.limit_in_bytes first.
  # Need to convert it from bytes to KB though.
  export APACHE_START_SERVERS="$(echo '' | awk -v memory_limit="$MEMORY_LIMIT" -f /usr/local/awk/print_max_children.awk)"
fi

# Remove NewRelic configuration file if not enabled.
if [ "$NEWRELIC_ENABLED" != true ]; then
  mv "${PHP_INI_DIR}/conf.d/docker-php-ext-newrelic.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-newrelic.ini.disabled" 2>/dev/null || true
fi

# Remove XDebug configuration if not enabled.
if [ "$XDEBUG_ENABLED" != true ]; then
  mv "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini.disabled" 2>/dev/null || true
fi

# Remove Opencensus configuration if not enabled.
if [ "$OPENCENSUS_ENABLED" != true ]; then
  mv "${PHP_INI_DIR}/conf.d/docker-php-ext-opencensus.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-opencensus.ini.disabled" 2>/dev/null || true
fi

# Function used to compare version numbers.
version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

# Environment variable backwards-compatibility.
[ "$XDEBUG_IDE_KEY" != "" ] && export XDEBUG_IDEKEY="$XDEBUG_IDE_KEY"
[ "$XDEBUG_REMOTE_HOST" != "" ] && export XDEBUG_CLIENT_HOST="$XDEBUG_REMOTE_HOST"
[ "$XDEBUG_REMOTE_PORT" != "" ] && export XDEBUG_CLIENT_PORT="$XDEBUG_REMOTE_PORT"
[ "$MAX_CHILDREN" != "" ] && export PM_MAX_CHILDREN="$MAX_CHILDREN"
[ "$MIN_SPARE_SERVERS" != "" ] && export PM_MIN_SPARE_SERVERS="$MIN_SPARE_SERVERS"
[ "$MAX_SPARE_SERVERS" != "" ] && export PM_MAX_SPARE_SERVERS="$MAX_SPARE_SERVERS"
[ "$MAX_REQUESTS" != "" ] && export PM_MAX_REQUESTS="$MAX_REQUESTS"
[ "$STATUS_PATH" != "" ] && export PM_STATUS_PATH="$STATUS_PATH"
[ "$TIMEOUT" != "" ] && export REQUEST_TERMINATE_TIMEOUT="$TIMEOUT"
[ "$STATUS_HOSTS_ALLOWED" != "" ] && export PM_STATUS_HOSTS_ALLOWED="$STATUS_HOSTS_ALLOWED"
[ "$STATUS_HOSTS_DENIED" != "" ] && export PM_STATUS_HOSTS_DENIED="$STATUS_HOSTS_DENIED"
[ "$NEWRELIC_DAEMON_PORT" != "" ] && export NEWRELIC_DAEMON_ADDRESS="$NEWRELIC_DAEMON_PORT"
[ "$NEWRELIC_DAEMON_WAIT" != "" ] && export NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT="$NEWRELIC_DAEMON_WAIT"
[ "$NEWRELIC_DAEMON_WAIT" != "" ] && export NEWRELIC_DAEMON_START_TIMEOUT="$NEWRELIC_DAEMON_WAIT"
[ "$NEWRELIC_HOST_DISPLAY_NAME" != "" ] && export NEWRELIC_PROCESS_HOST_DISPLAY_NAME="$NEWRELIC_HOST_DISPLAY_NAME"
[ "$NEWRELIC_AUTORUM_ENABLED" != "" ] && export NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT="$NEWRELIC_AUTORUM_ENABLED"
[ "$NEWRELIC_RECORD_SQL" != "" ] && export NEWRELIC_TRANSACTION_TRACER_RECORD_SQL="$NEWRELIC_RECORD_SQL"
[ "$NEWRELIC_APP_NAME" != "" ] && export NEWRELIC_APPNAME="$NEWRELIC_APP_NAME"

# Alternate spelling compatibility.
[ "$NEWRELIC_LICENSE" != "" ] && export NEWRELIC_LICENCE="$NEWRELIC_LICENSE"

# Build sedfile.
{
  if [ "$(version "$PHP_VERSION")" -lt "$(version 7.4.0)" ]; then
    echo COMMENT_WHEN_PHP_LT_74=";"
    echo COMMENT_WHEN_PHP_LT_80=";"

    echo COMMENT_WHEN_PHP_GE_73=";"
    echo COMMENT_WHEN_PHP_GE_74=""
    echo COMMENT_WHEN_PHP_GE_80=""
  elif [ "$(version "$PHP_VERSION")" -lt "$(version 8.0.0)" ]; then
    echo COMMENT_WHEN_PHP_LT_74=""
    echo COMMENT_WHEN_PHP_LT_80=";"

    echo COMMENT_WHEN_PHP_GE_73=";"
    echo COMMENT_WHEN_PHP_GE_74=";"
    echo COMMENT_WHEN_PHP_GE_80=""
  else
    echo COMMENT_WHEN_PHP_LT_74=""
    echo COMMENT_WHEN_PHP_LT_80=""

    echo COMMENT_WHEN_PHP_GE_73=";"
    echo COMMENT_WHEN_PHP_GE_74=";"
    echo COMMENT_WHEN_PHP_GE_80=";"
  fi

  env
} | awk -f /usr/local/awk/prepare_config_sedfile.awk > /tmp/.sedfile

#
# Update Apache configuration.
#

{
  find "$PHP_INI_DIR" -name '*.ini' -o -name '*.ini.disabled'
  find /etc/apache2 -maxdepth 1 -name "*.conf" 2>/dev/null || true
  find /etc/apache2/conf-available -maxdepth 1 -name "*.conf" 2>/dev/null || true
  find /etc/apache2/mods-available -maxdepth 1 -name "*.conf" 2>/dev/null || true
} | xargs sed -f /tmp/.sedfile -i

# Create the session directory if using files.
save_path="$(grep -E "^session\.save_(path|handler)" "$PHP_INI_DIR/php.ini" | sort | awk -f /usr/local/awk/extract_session_save_path.awk)"

if [ "$save_path" != "" ]; then
  mkdir -p "$save_path"
  chown -R www-data:www-data "$save_path"
fi

# Execute all entrypoint scripts.
find /docker-entrypoint.d -type f -executable -print0 | xargs -0 -I CMD CMD

# Start the interactive PHP interpreter if there is no FPM, and no arguments given.
if [ $# -lt 1 ]; then
  exec apache2-foreground
fi

# Arguments were given. Simply execute whatever was provided.
if [ $# -gt 0 ]; then
  exec "$@"
fi
