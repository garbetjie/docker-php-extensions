PHP in Docker
=============

A collection of PHP extensions bundled as super lightweight Docker images that make it simple to add & enable extensions
in your custom PHP Docker images.

Supported PHP versions: 8.0, 8.1, 8.2

## Table of contents

* [Usage](#usage)
* [Available extensions](#available-extensions)
<!-- * [Base images](#base-images) -->


## Usage

Using an extension in your custom image is a simple process consisting of two steps:

1. Copy in all files from the `garbetjie/php` extension image.
2. Run the setup script that installs any additional packages & performs any additional setup required by the extension.

```dockerfile
FROM php:8.0.22-cli-alpine3.15 AS php-80

# Copy in the extensions.
COPY --from=garbetjie/php:8.0-pdo_mysql / /
COPY --from=garbetjie/php:8.0-opcache / /
COPY --from=garbetjie/php:8.0-xdebug / /

# Run the setup script.
RUN wget -O- https://raw.githubusercontent.com/garbetjie/docker-php/main/install-dependencies.sh | sh


FROM php:8.2.1-cli-alpine3.17 AS php-82

COPY --from=garbetjie/php:8.2-mysqli / /
COPY --from=garbetjie/php:8.2-grpc / /

RUN wget -O- https://raw.githubusercontent.com/garbetjie/docker-php/main/install-dependencies.sh | sh
```

Extension images are tagged based on their short PHP version (`8.0`, `8.1` or `8.2`), and the extension name as shown in
the output of `php -m`.

For example, the `grpc` extension can be fetched from the `garbetjie/php:8.2-grpc` image. 


## Available extensions

The table below shows a support matrix of the available extensions, as well as which platforms & PHP versions they're
available for:

| extension     | Arch: linux/amd64 | Arch: linux/arm64 | PHP 8.0 | PHP 8.1 | PHP 8.2 | PHP 8.3 |
|---------------|-------------------|-------------------|---------|---------|---------|---------|
| amqp          | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| apcu          | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| bcmath        | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| bz2           | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| ds            | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| exif          | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| gd            | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| gettext       | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| gmp           | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| grpc          | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| igbinary      | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| imagick       | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| imap          | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| intl          | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| memcached     | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| memprof       | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| mongodb       | ✅                 | ✅                 | ✅       | ✅       | ✅       | ✅       |
| msgpack       | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| newrelic      | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| opcache       | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| opencensus    | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| opencensus    | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| opentelemetry | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| pcntl         | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| pdo_mysql     | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| pdo_sqlsrv    | ✅                 | ❌                 | ✅       | ✅       | ✅       |         |
| protobuf      | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| redis         | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| snappy        | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| soap          | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| sockets       | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| sqlsrv        | ✅                 | ❌                 | ✅       | ✅       | ✅       |         |
| ssh2          | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| xdebug        | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| yaml          | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
| zip           | ✅                 | ✅                 | ✅       | ✅       | ✅       |         |
    

<!--
## Base images

There are two base images available:

1. A `www` image based off of the official FPM image, and bundles NGiNX with it. It aims to make it easy to spin up an
   already-functional web server that is easy to configure through environment variables.

2. A `cli` image based off of the offic

[Full documentation]

### PHP

The environment variables below apply to all image variants, and are used to control the behaviour of PHP itself.

| Section              | Name                                        | INI equivalent                                                                                                                                                 | Default                             |
|----------------------|---------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| PHP Core             | DISPLAY_ERRORS                              | [display_errors](https://www.php.net/manual/en/errorfunc.configuration.php#ini.display-errors)                                                                 | "Off"                               |
|                      | ERROR_REPORTING                             | [error_reporting](https://www.php.net/manual/en/errorfunc.configuration.php#ini.error-reporting)                                                               | "E_ALL & ~E_DEPRECATED & ~E_STRICT" |
|                      | EXPOSE_PHP                                  | [expose_php](https://php.net/expose-php)                                                                                                                       | false                               |
|                      | HTML_ERRORS                                 | [html_errors](https://www.php.net/manual/en/errorfunc.configuration.php#ini.html-errors)                                                                       | "Off"                               |
|                      | MAX_EXECUTION_TIME                          | [max_execution_time](https://www.php.net/manual/en/info.configuration.php#ini.max-execution-time)                                                              | 30                                  |
|                      | MAX_INPUT_TIME                              | [max_input_time](https://www.php.net/manual/en/info.configuration.php#ini.max-input-time)                                                                      | 30                                  |
|                      | MAX_REQUEST_SIZE                            | [post_max_size](https://www.php.net/manual/en/ini.core.php#ini.post-max-size)                                                                                  | "8M"                                |
|                      | MEMORY_LIMIT                                | [memory_limit](https://www.php.net/manual/en/ini.core.php#ini.memory-limit)                                                                                    | "64M"                               |
|                      | OPCACHE_ENABLED                             | [opcache.enable](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.enable)                                                                   | true                                |
|                      | OPCACHE_CLI_ENABLED                         | [opcache.enable_cli](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.enable-cli)                                                           | false                               |
|                      | OPCACHE_MAX_ACCELERATED_FILES               | [opcache.max_accelerated_files](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.max-accelerated-files)                                     | 10000                               |
|                      | OPCACHE_PRELOAD                             | [opcache.preload](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.preload)                                                                 | ""                                  |
|                      | OPCACHE_REVALIDATE_FREQ                     | [opcache.revalidate_freq](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.revalidate-freq)                                                 | 2                                   |
|                      | OPCACHE_VALIDATE_TIMESTAMPS                 | [opcache.validate_timestamps](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.validate-timestamps)                                         | true                                |
|                      | OPCACHE_SAVE_COMMENTS                       | [opcache.save_comments](https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.save-comments)                                                     | true                                |
|                      | SESSION_COOKIE_NAME                         | [session.name](https://www.php.net/manual/en/session.configuration.php#ini.session.name)                                                                       | "PHPSESSID"                         |
|                      | SESSION_SAVE_HANDLER                        | [session.save_handler](https://www.php.net/manual/en/session.configuration.php#ini.session.save-handler)                                                       | "files"                             |
|                      | SESSION_SAVE_PATH                           | [session.save_path](https://www.php.net/manual/en/session.configuration.php#ini.session.save-path)                                                             | "/tmp/sessions"                     |
|                      | SYS_TEMP_DIR                                | [sys_temp_dir](https://www.php.net/manual/en/ini.list.php)                                                                                                     | "/tmp"                              |
|                      | TIMEZONE                                    | [date.timezone](https://www.php.net/manual/en/datetime.configuration.php#ini.date.timezone)                                                                    | "Etc/UTC"                           |
|                      | UPLOAD_MAX_FILESIZE                         | [upload_max_filesize](https://www.php.net/manual/en/ini.core.php#ini.upload-max-filesize)                                                                      | "8M"                                |
| New Relic extension  | NEWRELIC_ENABLED                            | [newrelic.enabled](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-enabled)                                       | false                               |
|                      | NEWRELIC_APPNAME                            | [newrelic.appname](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-appname)                                       | ""                                  |
|                      | NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT | [newrelic.browser_monitoring.auto_instrument](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-autorum)            | true                                |
|                      | NEWRELIC_DAEMON_LOGLEVEL                    | [newrelic.daemon.loglevel](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-daemon-loglevel)                       | "error"                             |
|                      | NEWRELIC_DAEMON_ADDRESS                     | [newrelic.daemon.address](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-daemon-port)                            | "@newrelic-daemon"                  |
|                      | NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT         | [newrelic.daemon.app_connect_timeout](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-daemon-app_connect_timeout) | 5                                   |
|                      | NEWRELIC_DAEMON_START_TIMEOUT               | [newrelic.daemon.start_timeout](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-daemon-start_timeout)             | 3                                   |
|                      | NEWRELIC_PROCESS_HOST_DISPLAY_NAME          | [newrelic.process_host.display_name](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-process_host-display_name)   | ""                                  |
|                      | NEWRELIC_LABELS                             | [newrelic.labels](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-labels)                                         | ""                                  |
|                      | NEWRELIC_LICENCE                            | [newrelic.license](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-license)                                       | ""                                  |
|                      | NEWRELIC_LOGLEVEL                           | [newrelic.loglevel](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-loglevel)                                     | "info"                              |
|                      | NEWRELIC_TRANSACTION_TRACER_RECORD_SQL      | [newrelic.transaction_tracer.record_sql](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-tt-sql)                  | "obfuscated"                        |
| OpenCensus extension | OPENCENSUS_ENABLED                          | N/A (Used to enable/disable the OpenCensus extension)                                                                                                          | false                               |
| XDebug extension     | XDEBUG_ENABLED                              | N/A (Used to enable/disable the XDebug extension)                                                                                                              | false                               |
|                      | XDEBUG_IDEKEY                               | [xdebug.idekey](https://xdebug.org/docs/all_settings#idekey)                                                                                                   | "IDEKEY"                            |
|                      | XDEBUG_CLIENT_HOST                          | [xdebug.client_host](https://xdebug.org/docs/all_settings#client_host)                                                                                         | "host.docker.internal"              |
|                      | XDEBUG_CLIENT_PORT                          | [xdebug.client_port](https://xdebug.org/docs/all_settings#client_port)                                                                                         | 9000                                |

> **Deprecated environment variables**
>
> The following environment variables were renamed or removed. Where variables are renamed or split out, backwards
> compatibility has been maintained as much as possible. If backwards compatibility could not be maintained, it will be 
> indicated:
> 
> * `XDEBUG_REMOTE_AUTOSTART` (removed)
> * `XDEBUG_REMOTE_HOST` (renamed to `XDEBUG_CLIENT_HOST`)
> * `XDEBUG_REMOTE_PORT` (renamed to `XDEBUG_CLIENT_PORT`)
> * `XDEBUG_IDE_KEY` (renamed to `XDEBUG_IDEKEY`)
> * `NEWRELIC_DAEMON_PORT` (renamed to `NEWRELIC_DAEMON_ADDRESS`)
> * `NEWRELIC_DAEMON_WAIT` (split out into `NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT` and `NEWRELIC_DAEMON_START_TIMEOUT`).
> * `NEWRELIC_HOST_DISPLAY_NAME` (renamed to `NEWRELIC_PROCESS_HOST_DISPLAY_NAME`).
> * `NEWRELIC_RECORD_SQL` (renamed to `NEWRELIC_TRANSACTION_TRACER_RECORD_SQL`).
> * `NEWRELIC_AUTORUM_ENABLED` (renamed to `NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT`).
> * `NEWRELIC_APP_NAME` (renamed to `NEWRELIC_APPNAME`).

### FPM

The following variables apply to PHP-FPM.

| Name                      | FPM INI equivalent                                                                                                 | Default           |
|---------------------------|--------------------------------------------------------------------------------------------------------------------|-------------------|
| LISTEN                    | [listen](https://www.php.net/manual/en/install.fpm.configuration.php#listen)                                       | "0.0.0.0:9000"    |
| PM                        | [pm](https://www.php.net/manual/en/install.fpm.configuration.php#pm)                                               | "static"          |
| PM_MAX_CHILDREN           | [pm.max_children](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-children)                     | 0                 |
| PM_MIN_SPARE_SERVERS      | [pm.min_spare_servers](https://www.php.net/manual/en/install.fpm.configuration.php#pm.min-spare-servers)           | 1                 |
| PM_MAX_SPARE_SERVERS      | [pm.max_spare_servers](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-spare-servers)           | 3                 |
| PM_MAX_REQUESTS           | [pm.max_requests](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-requests)                     | 10000             |
| PM_STATUS_PATH            | [pm.status_path](https://www.php.net/manual/en/install.fpm.configuration.php#pm.status-path)                       | "/_/status"       |
| REQUEST_SLOWLOG_TIMEOUT   | [request_slowlog_timeout](https://www.php.net/manual/en/install.fpm.configuration.php#request-slowlog-timeout)     | 0                 |
| REQUEST_TERMINATE_TIMEOUT | [request_terminate_timeout](https://www.php.net/manual/en/install.fpm.configuration.php#request-terminate-timeout) | 60                |
| SLOWLOG                   | [slowlog](https://www.php.net/manual/en/install.fpm.configuration.php#slowlog)                                     | "/proc/self/fd/2" |

> **Deprecated environment variables**
>
> The following environment variables were renamed to reflect the actual INI config key more closely.
> Backwards compatibility has been maintained.
>
> * `MAX_CHILDREN` was renamed to `PM_MAX_CHILDREN`.
> * `MIN_SPARE_SERVERS` was renamed to `PM_MIN_SPARE_SERVERS`.
> * `MAX_SPARE_SERVERS` was renamed to `PM_MAX_SPARE_SERVERS`.
> * `MAX_REQUESTS` was renamed to `PM_MAX_REQUESTS`.
> * `STATUS_PATH` was renamed to `PM_STATUS_PATH`.
> * `TIMEOUT` was renamed to `REQUEST_TERMINATE_TIMEOUT`.

### NGiNX

The following variables apply to NGiNX. There is an overlap between these variables, and those that are configurable for
PHP-FPM. In some instances, the NGiNX configuration overrides some of the defaults for PHP-FPM.

| Name                      | NGiNX config equivalent                                                                                           | Default                                                                                                                                                             |
|---------------------------|-------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ABSOLUTE_REDIRECT         | [absolute_redirect](http://nginx.org/en/docs/http/ngx_http_core_module.html#absolute_redirect)                    | "on"                                                                                                                                                                |
| CONTENT_EXPIRY_DURATION   | [expires](http://nginx.org/en/docs/http/ngx_http_headers_module.html#expires)                                     | "off"                                                                                                                                                               |
| CONTENT_EXPIRY_EXTENSIONS | n/a (pipe-delimited extensions to apply "Expires" and "Cache-Control" headers to)                                 | "js\|css\|png\|jpg\|jpeg\|gif\|svg\|ico\|ttf\|woff\|woff2"                                                                                                          |
| FASTCGI_BUFFER_SIZE       | [fastcgi_buffer_size](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffer_size)             | "64k"                                                                                                                                                               |
| FASTCGI_BUFFERING         | [fastcgi_buffering](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffering)                 | "on"                                                                                                                                                                |
| FASTCGI_BUFFERS           | [fastcgi_buffers](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_buffers)                     | "32 32k"                                                                                                                                                            |
| FASTCGI_BUSY_BUFFERS_SIZE | [fastcgi_busy_buffers_size](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_busy_buffers_size) | "96k"                                                                                                                                                               |
| GZIP_TYPES                | [gzip_types](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_types)                                  | "application/ecmascript application/javascript application/json application/xhtml+xml application/xml text/css text/ecmascript text/javascript text/plain text/xml" |
| GZIP_PROXIED              | [gzip_types](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_proxied)                                | "any"                                                                                                                                                               |
| LISTEN                    | [fastcgi_pass](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass)                           | "/var/run/php-fpm.sock"                                                                                                                                             |
| PORT                      | [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen)                                          | 80                                                                                                                                                                  |
| PORT_IN_REDIRECT          | [port_in_redirect](http://nginx.org/en/docs/http/ngx_http_core_module.html#port_in_redirect)                      | "off"                                                                                                                                                               |
| ROOT                      | [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root)                                              | "/srv/public"                                                                                                                                                       |
| PM_STATUS_HOSTS_ALLOWED   | [allow](http://nginx.org/en/docs/http/ngx_http_access_module.html#allow)                                          | "127.0.0.1"                                                                                                                                                         |
| PM_STATUS_HOSTS_DENIED    | [deny](http://nginx.org/en/docs/http/ngx_http_access_module.html#deny)                                            | "all"                                                                                                                                                               |
| REQUEST_TERMINATE_TIMEOUT | [fastcgi_read_timeout](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_read_timeout)           | 60                                                                                                                                                                  |

> **Deprecated environment variables**
>
> The following environment variables were renamed, and backwards compatibility has been maintained.
>
> * `STATUS_HOSTS_ALLOWED` was renamed to `PM_STATUS_HOSTS_ALLOWED`.
> * `STATUS_HOSTS_DENIED` was renamed to `PM_STATUS_HOSTS_DENIED`.
> * `TIMEOUT` was renamed to `REQUEST_TERMINATE_TIMEOUT`.

## Changelog

* **2021-08-12**
  * Change XDebug log level to 7 from 10.

* **2021-08-11**
  * Change to using a multi-stage build file (this should help with preventing nginx images from being pushed all the time).
  * Copy installation scripts after `grpc` extension installation. This will prevent the grpc installation from happening
    when extensions are added/removed.

* **2021-07-27**
  * Make New Relic available on PHP 8.
  * Add `grpc`, `protobuf` and `yaml` extensions.
  * Refactor how the extensions are downloaded & installed.
  * Remove references to ZTS.
  * Remove `dash` shell.
  * Switch from `dumb-init` to `tini`.
  * Make `opencensus` available on PHP 8.
  * Bump extension versions:
    * `opencensus`: 007b35d8f7ed21cab9aa47406578ae02f73f91c5 -> 0.3.0

* **2021-07-21**
  * Upgrade PHP versions to `7.3.29`, `7.4.21` & `8.0.8`.
  * Upgrade Alpine to `3.14`.
  * Bump extension versions:
    * `newrelic`: 9.16.0.295 -> 9.17.1.301
    * `igbinary`: 3.2.1 -> 3.2.3
    * `imagick`: 3.4.4 -> 3.5.0
    * `redis`: 5.3.2 -> 5.3.4
    * `xdebug`: 3.0.2 -> 3.0.4

* **2021-04-21**
  * Ensure `imagick` extension is available on PHP 8.0 too.

* **2021-04-20**
  * Add `imagick` extension.

* **2021-03-16**
  * Add configuration items:
    * `FASTCGI_BUFFERING`
    * `FASTCGI_BUFFER_SIZE`
    * `FASTCGI_BUFFERS`
    * `FASTCGI_BUSY_BUFFERS_SIZE`
  * Increase default values for `FASTCGI_BUFFER_SIZE` and `FASTCGI_BUSY_BUFFERS_SIZE`.
  * Turn FastCGI buffering on by default.

* See [CHANGELOG.md](CHANGELOG.md) for a full history.
-->
