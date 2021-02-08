PHP in Docker
=============

An all-in-one PHP Docker image that comes preconfigured with a large range of extensions; and can be configured using
environment variables. Supports PHP 7.2, 7.3, 7.4 & early support for 8.0.

See the [list of available extensions](#available-extensions) to see whether the extension you need is included.

## Table of contents

* [Using images](#using-images)
* [Variants available](#available-variants)
* [Configuration](#configuration)
    * [Templating](#templating)
    * [Startup scripts](#startup-scripts)
    * [PHP](#php)
    * [FPM](#fpm)
    * [NGiNX](#nginx)
* [Known Issues](#known-issues)
* [Available extensions](#available-extensions)
* [Changelog](#changelog)

## Using images

Docker images are available on Docker Hub, and can be pulled using the following command:

    docker pull garbetjie/php:7.4-fpm

Additional images can be found on [Docker Hub](https://hub.docker.com/r/garbetjie/php).

> **A note on PHP 8.0 images**
> 
> PHP 8.0 is still in an early release phase. As such, not all extensions installed are available in the PHP 8.0 images,
> and there is no CLI version for PHP 8.0. As the missing extensions become compatible with PHP 8.0, they will be added.  

## Available variants

There are three variants that are available: `cli`, `fpm` and `nginx`. Each one is available for each PHP version.
For example, these are the variants available:

* **`garbetjie/php:7.X-cli`**
  Thread-safe version of PHP, with the [`parallel`](https://www.php.net/parallel) extension (but disabled) by default.
    
* **`garbetjie/php:[7.x|8.0]-fpm`**
  PHP installed with PHP-FPM. All error logs are written to the container's `stderr`.

* **`garbetjie/php:[7.x|8.0]-nginx`**
  PHP-FPM installed with the NGiNX webserver. This effectively turns the Docker container into a self-contained web
  server.
  
  Access logs are written to the container's `stdout`, and PHP-FPM logs are written to the container's `stderr`.
    

## Configuration

There are a number of configuration options within PHP that are configurable through environment variables. Many of these
are available across all variants, and some of them apply to specific image variants only.

### Templating

Configuration is compiled using `sed`, and uses a template format of `{{ VAR_NAME }}` (surrounding spaces matter)
as placeholder values for configuration values. By default, all environment variables are available for templating in
configuration files.

### Startup scripts

If you need to execute any startup scripts, simply place them in the `/docker-entrypoint.d` directory, and ensure they
are executable. These startup scripts are executed after all configuration templating is complete, but before any
services or processes are started.

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

| Name                      | FPM INI equivalent                                                                                                 | Default        |
|---------------------------|--------------------------------------------------------------------------------------------------------------------|----------------|
| LISTEN                    | [listen](https://www.php.net/manual/en/install.fpm.configuration.php#listen)                                       | "0.0.0.0:9000" |
| PM                        | [pm](https://www.php.net/manual/en/install.fpm.configuration.php#pm)                                               | "static"       |
| PM_MAX_CHILDREN           | [pm.max_children](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-children)                     | 0              |
| PM_MIN_SPARE_SERVERS      | [pm.min_spare_servers](https://www.php.net/manual/en/install.fpm.configuration.php#pm.min-spare-servers)           | 1              |
| PM_MAX_SPARE_SERVERS      | [pm.max_spare_servers](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-spare-servers)           | 3              |
| PM_MAX_REQUESTS           | [pm.max_requests](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-requests)                     | 10000          |
| PM_STATUS_PATH            | [pm.status_path](https://www.php.net/manual/en/install.fpm.configuration.php#pm.status-path)                       | "/_/status"    |
| REQUEST_TERMINATE_TIMEOUT | [request_terminate_timeout](https://www.php.net/manual/en/install.fpm.configuration.php#request-terminate-timeout) | 60             |

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

| Name                      | NGiNX config equivalent                                                                                 | Default                                                                                                                                                             |
|---------------------------|---------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ABSOLUTE_REDIRECT         | [absolute_redirect](http://nginx.org/en/docs/http/ngx_http_core_module.html#absolute_redirect)          | "on"                                                                                                                                                                |
| GZIP_TYPES                | [gzip_types](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_types)                        | "application/ecmascript application/javascript application/json application/xhtml+xml application/xml text/css text/ecmascript text/javascript text/plain text/xml" |
| GZIP_PROXIED              | [gzip_types](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_proxied)                      | "any"                                                                                                                                                               |
| LISTEN                    | [fastcgi_pass](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass)                 | "/var/run/php-fpm.sock"                                                                                                                                             |
| PORT                      | [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen)                                | 80                                                                                                                                                                  |
| PORT_IN_REDIRECT          | [port_in_redirect](http://nginx.org/en/docs/http/ngx_http_core_module.html#port_in_redirect)            | "off"                                                                                                                                                               |
| ROOT                      | [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root)                                    | "/app/public"                                                                                                                                                       |
| PM_STATUS_HOSTS_ALLOWED   | [allow](http://nginx.org/en/docs/http/ngx_http_access_module.html#allow)                                | "127.0.0.1"                                                                                                                                                         |
| PM_STATUS_HOSTS_DENIED    | [deny](http://nginx.org/en/docs/http/ngx_http_access_module.html#deny)                                  | "all"                                                                                                                                                               |
| REQUEST_TERMINATE_TIMEOUT | [fastcgi_read_timeout](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_read_timeout) | 60                                                                                                                                                                  |

> **Deprecated environment variables**
>
> The following environment variables were renamed, and backwards compatibility has been maintained.
>
> * `STATUS_HOSTS_ALLOWED` was renamed to `PM_STATUS_HOSTS_ALLOWED`.
> * `STATUS_HOSTS_DENIED` was renamed to `PM_STATUS_HOSTS_DENIED`.
> * `TIMEOUT` was renamed to `REQUEST_TERMINATE_TIMEOUT`.

## Available extensions

The following extensions are available:

```
[PHP Modules]
amqp  (7.x images only)
bcmath
bz2
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
gmp
hash
iconv
igbinary
imap
intl
json
libxml
mbstring
memcached
msgpack
mysqlnd
newrelic  (7.x images only)
opencensus  (7.x images only)
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
soap
sockets
sodium
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Xdebug
Zend OPcache
```


## Changelog

* **2021-02-08**
  * Disable `opencensus` extension by default.
  * Rename the following configs with backwards compatibility:
    * `NEWRELIC_APP_NAME` -> `NEWRELIC_APPNAME`
  * Enable `NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT` by default.
  * Drop support for PHP 7.2, as it is [end of life](https://www.php.net/supported-versions.php).
  * Upgrade PHP versions to `7.3.27`, `7.4.15` & `8.0.2`.
  * Upgrade to Alpine 3.13.
  * Remove ZTS-safe versions - [support is limited in PHP 8 on Alpine Linux](https://github.com/docker-library/php/pull/1076).

* **2021-02-04**
  * Remove the additional & unnecessary `/opt/newrelic/newrelic.cfg` config file.
  * Add date-based image tags (eg: `7.4-nginx-20210204`).
  
* **2021-02-03**
  * Remove the use of a custom wait script for New Relic - this is configurable by the agent.
  * Split `NEWRELIC_DAEMON_WAIT` into separate configs `NEWRELIC_DAEMON_START_TIMEOUT` and `NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT`.
  * Rename the following configs with backwards compatibility:
    * `NEWRELIC_DAEMON_PORT` -> `NEWRELIC_DAEMON_ADDRESS`
    * `NEWRELIC_HOST_DISPLAY_NAME` -> `NEWRELIC_PROCESS_HOST_DISPLAY_NAME`
    * `NEWRELIC_AUTORUM_ENABLED` -> `NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT`
    * `NEWRELIC_RECORD_SQL` -> `NEWRELIC_TRANSACTION_TRACER_RECORD_SQL`

* **2021-02-02**
  * Upgrade `newrelic`: 9.15.0.293 -> 9.16.0.295
  * Update the `newrelic` configuration file to the latest.
  * Add support for alternate spelling of `NEWRELIC_LICENCE` (`NEWRELIC_LICENSE` is also allowed).

* **2021-01-18**
  * Upgrade extensions:
    * `igbinary`: 3.1.2 -> 3.2.1
    * `msgpack`: 2.1.0 -> 2.1.2
    * `redis`: 5.3.0 -> 5.3.2
    * `newrelic`: 9.11.0.267 -> 9.15.0.293
  * Ensure `igbinary`, `msgpack` and `redis` extensions are available on PHP 8.0.

* See [CHANGELOG.md](CHANGELOG.md) for a full history.
