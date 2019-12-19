#!/usr/bin/env sh

set -e

# Remove NewRelic configuration file if not enabled.
if [ "$NEWRELIC_ENABLED" != true ]; then
    if test -f "${PHP_INI_DIR}/conf.d/docker-php-ext-newrelic.ini"; then
        mv "${PHP_INI_DIR}/conf.d/docker-php-ext-newrelic.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-newrelic.ini.disabled"
    fi
fi

# Remove XDebug configuration if not enabled.
if [ "$XDEBUG_ENABLED" != true ]; then
    if test -f "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini"; then
        mv "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini.disabled"
    fi
fi

# Remove Opencensus configuration if not enabled.
if [ "$OPENCENSUS_ENABLED" != true ]; then
    if test -f "${PHP_INI_DIR}/conf.d/docker-php-ext-opencensus.ini"; then
      mv "${PHP_INI_DIR}/conf.d/docker-php-ext-opencensus.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-opencensus.ini.disabled"
    fi
fi

# Remove Parallel configuration if not enabled.
if [ "$PARALLEL_ENABLED" != true ]; then
    if test -f "${PHP_INI_DIR}/conf.d/docker-php-ext-parallel.ini"; then
      mv "${PHP_INI_DIR}/conf.d/docker-php-ext-parallel.ini" "${PHP_INI_DIR}/conf.d/docker-php-ext-parallel.ini.disabled"
    fi
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
esh -o /usr/local/etc/php-fpm.conf /usr/local/etc/php-fpm.conf

# Comment out configuration that isn't available in 7.2
if [ "$(version "$PHP_VERSION")" -lt "$(version 7.3.0)" ]; then
    sed -i 's/^decorate_workers_output/\;decorate_workers_output/;s/^log_limit/\;log_limit/' /usr/local/etc/php-fpm.conf
fi

# Substitute values in the PHP ini files.
for src_file in "$PHP_INI_DIR"/**/*.ini "$PHP_INI_DIR"/**/*.ini.disabled "$PHP_INI_DIR"/*.ini /opt/newrelic/newrelic.cfg; do
  esh -o "$src_file" "$src_file"
done

# If nginx is available, then substitute values in the nginx configuration files.
if command -v nginx 1>/dev/null; then
  for src_file in /etc/nginx/*.conf /etc/nginx/**/*.conf; do
    esh -o "$src_file" "$src_file"
  done
fi

# Start the daemon, before executing the main script.
/usr/local/bin/start-newrelic-daemon.sh || true

# Only start runit if FPM is available.
if [ $# -lt 1 ] && (echo "$PHP_EXTRA_CONFIGURE_ARGS" | grep -q -F -- '-fpm'); then
  terminate() {
    pkill -SIGHUP runsvdir
  }

  trap terminate TERM INT
  runsvdir -P /etc/services &
  wait "$!"

  exit 0
fi

# Start the interactive PHP interpreter if there is no FPM, and no arguments given.
if [ $# -lt 1 ] && (! echo "$PHP_EXTRA_CONFIGURE_ARGS" | grep -q -F -- '-fpm'); then
  exec php -a
fi

# Arguments were given. Simply execute whatever was provided.
if [ $# -gt 0 ]; then
  exec "$@"
fi
