#!/usr/bin/env dash

set -e

if [ "$MAX_CHILDREN" -lt 1 ]; then
  # See https://github.com/moby/moby/issues/20688#issuecomment-188923858 for why we check memory.limit_in_bytes first.
  # Need to convert it from bytes to KB though.
  export MAX_CHILDREN="$(echo '' | awk -v memory_limit="$MEMORY_LIMIT" -f /usr/local/awk/print_max_children.awk)"
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

# Remove Parallel configuration if not enabled.
if [ "$PARALLEL_ENABLED" != true ]; then
  mv "${PHP_INI_DIR}/conf.d/docker-php-ext-parallel.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-parallel.ini.disabled" 2>/dev/null || true
fi

# Function used to compare version numbers.
version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

# Environment variable backwards-compatibility.
[ "$XDEBUG_IDE_KEY" != "" ] && export XDEBUG_IDEKEY="$XDEBUG_IDE_KEY"
[ "$XDEBUG_REMOTE_HOST" != "" ] && export XDEBUG_CLIENT_HOST="$XDEBUG_REMOTE_HOST"
[ "$XDEBUG_REMOTE_PORT" != "" ] && export XDEBUG_CLIENT_PORT="$XDEBUG_REMOTE_PORT"

# Build sedfile.
{
  if [ "$(version "$PHP_VERSION")" -lt "$(version 7.3.0)" ]; then
    echo COMMENT_WHEN_PHP_LT_73=";"
    echo COMMENT_WHEN_PHP_LT_74=";"
    echo COMMENT_WHEN_PHP_LT_80=";"

    echo COMMENT_WHEN_PHP_GE_73=""
    echo COMMENT_WHEN_PHP_GE_74=""
    echo COMMENT_WHEN_PHP_GE_80=""
  elif [ "$(version "$PHP_VERSION")" -lt "$(version 7.4.0)" ]; then
    echo COMMENT_WHEN_PHP_LT_73=""
    echo COMMENT_WHEN_PHP_LT_74=";"
    echo COMMENT_WHEN_PHP_LT_80=";"

    echo COMMENT_WHEN_PHP_GE_73=";"
    echo COMMENT_WHEN_PHP_GE_74=""
    echo COMMENT_WHEN_PHP_GE_80=""
  elif [ "$(version "$PHP_VERSION")" -lt "$(version 8.0.0)" ]; then
    echo COMMENT_WHEN_PHP_LT_73=""
    echo COMMENT_WHEN_PHP_LT_74=""
    echo COMMENT_WHEN_PHP_LT_80=";"

    echo COMMENT_WHEN_PHP_GE_73=";"
    echo COMMENT_WHEN_PHP_GE_74=";"
    echo COMMENT_WHEN_PHP_GE_80=""
  else
    echo COMMENT_WHEN_PHP_LT_73=""
    echo COMMENT_WHEN_PHP_LT_74=""
    echo COMMENT_WHEN_PHP_LT_80=""

    echo COMMENT_WHEN_PHP_GE_73=";"
    echo COMMENT_WHEN_PHP_GE_74=";"
    echo COMMENT_WHEN_PHP_GE_80=";"
  fi

  if echo "$LISTEN" | grep -q "/"; then
    echo NGINX_LISTEN_PREFIX="unix:"
  else
    echo NGINX_LISTEN_PREFIX=""
  fi

  env
} | awk -f /usr/local/awk/prepare_config_sedfile.awk > /usr/local/config_sedfile

#
# Update FPM configuration.
#

{
  find "$PHP_INI_DIR" -name '*.ini' -o -name '*.ini.disabled'
  find /etc/nginx -name "*.conf" 2>/dev/null || true
  echo /opt/newrelic/newrelic.cfg /usr/local/etc/php-fpm.conf
} | xargs sed -f /usr/local/config_sedfile -i

# Create the session directory if using files.
save_path="$(grep -E "^session\.save_(path|handler)" "$PHP_INI_DIR/php.ini" | sort | awk -f /usr/local/awk/extract_session_save_path.awk)"

if [ "$save_path" != "" ]; then
  mkdir -p "$save_path"
  chown -R www-data:www-data "$save_path"
fi

# Execute all entrypoint scripts.
find /docker-entrypoint.d -type f -executable -print0 | xargs -0 -I CMD CMD

# Only start runit if FPM is available.
if [ $# -lt 1 ] && (echo "$PHP_EXTRA_CONFIGURE_ARGS" | grep -q -F -- '-fpm'); then
  terminate() {
    pkill -SIGHUP runsvdir
  }

  trap terminate TERM INT
  runsvdir -P /etc/runsv.d &
  wait "$!"

  exit 0
fi

# Start the daemon, before executing the main script. This is to ensure a sacrificial PHP process is used to start up the
# New Relic daemon. The NGiNX & FPM variants don't need this.
/usr/local/bin/start-newrelic-daemon.sh || true

# Start the interactive PHP interpreter if there is no FPM, and no arguments given.
if [ $# -lt 1 ] && (! echo "$PHP_EXTRA_CONFIGURE_ARGS" | grep -q -F -- '-fpm'); then
  exec php -a
fi

# Arguments were given. Simply execute whatever was provided.
if [ $# -gt 0 ]; then
  exec "$@"
fi
