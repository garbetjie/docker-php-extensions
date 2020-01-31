PHP in Docker
=============

An all-in-one PHP Docker image that comes preconfigured with a large range of extensions; and can be configured using
environment variables. Supports PHP 7.2, 7.3 & 7.4.

See the [list of available extensions](#available-extensions) to see whether the extension you need is included.

## Table of contents

* [Using images](#using-images)
* [Variants available](#available-variants)
* [Configuration](#configuration)
    * [Templating](#templating)
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

## Available variants

There are three variants that are available: `cli`, `fpm` and `nginx`. Each one is available for each PHP version.
For example, these are the variants available:

* **`garbetjie/php:7.X-cli`**
  Thread-safe version of PHP, with the [`parallel`](https://www.php.net/parallel) extension (but disabled) by default.
    
* **`garbetjie/php:7.X-fpm`**
  PHP installed with PHP-FPM. All error logs are written to the container's `stderr`.

* **`garbetjie/php:7.X-nginx`**
  PHP-FPM installed with the NGiNX webserver. This effectively turns the Docker container into a self-contained web
  server.
  
  Access logs are written to the container's `stdout`, and PHP-FPM logs are written to the container's `stderr`.
    

## Configuration

There are a number of configuration options within PHP that are configurable through environment variables. Many of these
are available across all variants, and some of them apply to specific image variants only.

### Templating

Configuration is injected via shell templating. [ESH](https://github.com/jirutka/esh) is the templating engine that is
used to build up configuration files. Any custom configuration files can also make use of ESH's syntax. 

### PHP

The environment variables below apply to all image variants, and are used to control the behaviour of PHP itself.

| Section              | Name                       | INI equivalent                                                                                                                                               | Default                             |
|----------------------|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| PHP Core             | DISPLAY_ERRORS             | [display_errors](https://www.php.net/manual/en/errorfunc.configuration.php#ini.display-errors)                                                               | "Off"                               |
|                      | ERROR_REPORTING            | [error_reporting](https://www.php.net/manual/en/errorfunc.configuration.php#ini.error-reporting)                                                             | "E_ALL & ~E_DEPRECATED & ~E_STRICT" |
|                      | HTML_ERRORS                | [html_errors](https://www.php.net/manual/en/errorfunc.configuration.php#ini.html-errors)                                                                     | "Off"                               |
|                      | MAX_EXECUTION_TIME         | [max_execution_time](https://www.php.net/manual/en/info.configuration.php#ini.max-execution-time)                                                            | 30                                  |
|                      | MAX_INPUT_TIME             | [max_input_time](https://www.php.net/manual/en/info.configuration.php#ini.max-input-time)                                                                    | 30                                  |
|                      | MAX_REQUEST_SIZE           | [post_max_size](https://www.php.net/manual/en/ini.core.php#ini.post-max-size)                                                                                | "8M"                                |
|                      | MEMORY_LIMIT               | [memory_limit](https://www.php.net/manual/en/ini.core.php#ini.memory-limit)                                                                                  | "64M"                               |
|                      | SESSION_COOKIE_NAME        | [session.name](https://www.php.net/manual/en/session.configuration.php#ini.session.name)                                                                     | "PHPSESSID"                         |
|                      | SESSION_SAVE_HANDLER       | [session.save_handler](https://www.php.net/manual/en/session.configuration.php#ini.session.save-handler)                                                     | "files"                             |
|                      | SESSION_SAVE_PATH          | [session.save_path](https://www.php.net/manual/en/session.configuration.php#ini.session.save-path)                                                           | "/tmp/sessions"                     |
|                      | TIMEZONE                   | [date.timezone](https://www.php.net/manual/en/datetime.configuration.php#ini.date.timezone)                                                                  | "Etc/UTC"                           |
|                      | UPLOAD_MAX_FILESIZE        | [upload_max_filesize](https://www.php.net/manual/en/ini.core.php#ini.upload-max-filesize)                                                                    | "8M"                                |
| New Relic extension  | NEWRELIC_ENABLED           | N/A (Used to enable/disable the New Relic extension)                                                                                                         | false                               |
|                      | NEWRELIC_APP_NAME          | [newrelic.appname](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-appname)                                     | ""                                  |
|                      | NEWRELIC_AUTORUM_ENABLED   | [newrelic.browser_monitoring.auto_instrument](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-autorum)          | 0                                   |
|                      | NEWRELIC_DAEMON_LOGLEVEL   | [newrelic.daemon.loglevel](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-daemon-loglevel)                     | "error"                             |
|                      | NEWRELIC_DAEMON_PORT       | [newrelic.daemon.port](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-daemon-port)                             | "@newrelic-daemon"                  |
|                      | NEWRELIC_DAEMON_WAIT       | N/A (Number of seconds to wait for New Relic daemon to connect to the reporting servers)                                                                     | 3                                   |
|                      | NEWRELIC_HOST_DISPLAY_NAME | [newrelic.process_host.display_name](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-process_host-display_name) | ""                                  |
|                      | NEWRELIC_LABELS            | [newrelic.labels](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-labels)                                       | ""                                  |
|                      | NEWRELIC_LICENCE           | [newrelic.license](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-license)                                     | ""                                  |
|                      | NEWRELIC_LOGLEVEL          | [newrelic.loglevel](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-loglevel)                                   | "info"                              |
|                      | NEWRELIC_RECORD_SQL        | [newrelic.transaction_tracer.record_sql](https://docs.newrelic.com/docs/agents/php-agent/configuration/php-agent-configuration#inivar-tt-sql)                | "obfuscated"                        |
| OpenCensus extension | OPENCENSUS_ENABLED         | N/A (Used to enable/disable the OpenCensus extension)                                                                                                        | false                               |
| XDebug extension     | XDEBUG_ENABLED             | N/A (Used to enable/disable the XDebug extension)                                                                                                            | false                               |
|                      | XDEBUG_IDE_KEY             | [xdebug.idekey](https://xdebug.org/docs/all_settings#idekey)                                                                                                 | "IDEKEY"                            |
|                      | XDEBUG_REMOTE_AUTOSTART    | [xdebug.remote_autostart](https://xdebug.org/docs/all_settings#remote_autostart)                                                                             | 0                                   |
|                      | XDEBUG_REMOTE_HOST         | [xdebug.remote_host](https://xdebug.org/docs/all_settings#remote_host)                                                                                       | "192.168.99.1"                      |
|                      | XDEBUG_REMOTE_PORT         | [xdebug.remote_port](https://xdebug.org/docs/all_settings#remote_port)                                                                                       | 9000                                |

### FPM

The following variables apply to PHP-FPM.

| Name              | FPM INI equivalent                                                                                                 | Default        |
|-------------------|--------------------------------------------------------------------------------------------------------------------|----------------|
| PM                | [pm](https://www.php.net/manual/en/install.fpm.configuration.php#pm)                                               | "static"       |
| LISTEN            | [listen](https://www.php.net/manual/en/install.fpm.configuration.php#listen)                                       | "0.0.0.0:9000" |
| MAX_CHILDREN      | [pm.max_children](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-children)                     | 0              |
| MIN_SPARE_SERVERS | [pm.min_spare_servers](https://www.php.net/manual/en/install.fpm.configuration.php#pm.min-spare-servers)           | 1              |
| MAX_SPARE_SERVERS | [pm.max_spare_servers](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-spare-servers)           | 3              |
| MAX_REQUESTS      | [pm.max_requests](https://www.php.net/manual/en/install.fpm.configuration.php#pm.max-requests)                     | 10000          |
| STATUS_PATH       | [pm.status_path](https://www.php.net/manual/en/install.fpm.configuration.php#pm.status-path)                       | "/_/status"    |
| TIMEOUT           | [request_terminate_timeout](https://www.php.net/manual/en/install.fpm.configuration.php#request-terminate-timeout) | 60             |

### NGiNX

The following variables apply to NGiNX. There is an overlap between these variables, and those that are configurable for
PHP-FPM. In some instances, the NGiNX configuration overrides some of the defaults for PHP-FPM.

| Name                 | NGiNX config equivalent                                                                                 | Default                                                                                                                                                             |
|----------------------|---------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| GZIP_TYPES           | [gzip_types](http://nginx.org/en/docs/http/ngx_http_gzip_module.html#gzip_types)                        | "application/ecmascript application/javascript application/json application/xhtml+xml application/xml text/css text/ecmascript text/javascript text/plain text/xml" |
| LISTEN               | [fastcgi_pass](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_pass)                 | "/var/run/php-fpm.sock"                                                                                                                                             |
| PORT                 | [listen](http://nginx.org/en/docs/http/ngx_http_core_module.html#listen)                                | 80                                                                                                                                                                  |
| ROOT                 | [root](http://nginx.org/en/docs/http/ngx_http_core_module.html#root)                                    | "/app/public"                                                                                                                                                       |
| STATUS_HOSTS_ALLOWED | [allow](http://nginx.org/en/docs/http/ngx_http_access_module.html#allow)                                | "172.16.0.0/12 127.0.0.1"                                                                                                                                           |
| STATUS_HOSTS_DENIED  | [deny](http://nginx.org/en/docs/http/ngx_http_access_module.html#deny)                                  | "all"                                                                                                                                                               |
| TIMEOUT              | [fastcgi_read_timeout](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_read_timeout) | 60                                                                                                                                                                  |

## Known Issues

* When using a version of PHP with thread safety enabled, you cannot use both the `opencensus` and `parallel` extensions
  at the same time. PHP will exit with a segmentation fault.

## Available extensions

The following extensions are available:

```
[PHP Modules]
amqp
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
newrelic
opencensus
openssl
parallel  (*-zts-cli versions only)
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

* **2020-01-31**
    * Bump New Relic version to 9.6.1.256.
    * Add `$NEWRELIC_LOGLEVEL` configuration option.
    * Ensure `$NEWRELIC_DAEMON_LOGLEVEL` is respected.
    * Update Alpine versions to 3.11.
    * Update to PHP 7.2.27, 7.3.14, 7.4.2.
    * Increase `$NEWRELIC_DAEMON_WAIT` to 5 seconds.
    * Fix bug in which ZTS wasn't being calculated correctly. Only caused issues with `-cli` images. 

* **2020-01-08**
    * Bug fix: Incorrect ownership on `/var/tmp/nginx`.
    * Bug fix: Create PHP session directory if files are being used.
    * Reduce interval between php-fpm checks to 0.25 seconds from 1 second.

* **2019-12-19**
    * Add NGiNX image.
    * Bump PHP versions (7.4.1, 7.3.13, 7.2.26).
    * Merge build commands into Dockerfile again `-_-`
    * Add missing templating to New Relic Daemon config.
    * Ensure NGiNX waits for FPM to start first.
    
* **2019-12-17**
    * Remove non-ZTS CLI image.
    * Disable parallel extension by default.
    * Move build commands into separate files.
    
* **2019-12-14**
    * Add WebP support to GD.

* **2019-12-13**
    * Add PHP 7.4 images.
    * Upgrade New Relic daemon for PHP 7.4 support.
    * Add `$SESSION_COOKIE_NAME` configuration, and fix `$SESSSION_SAVE_*` configuration not being used.

* **2019-11-21**
    * Add ability to enable/disable the `opencensus` extension. Set to disabled by default.

* **2019-11-20**
    * Add thread safe images (`7.3-zts-cli` and `7.2-zts-cli`).
    * Add `parallel` extension in thread safe images.
    * Update PHP 7.3 to 7.3.11.
    * Update PHP 7.2 to 7.2.24.

* **2019-11-14**
    * Add `$NEWRELIC_HOST_DISPLAY_NAME` for configuring the display name of the server in the New Relic UI.

* **2019-11-11**
    * Add `$NEWRELIC_DAEMON_LOGLEVEL` for configuring the daemon logging level.
    * Update the starting of the Daemon process to implement a throwaway PHP process used to "prime" the daemon.
    * Change the default value of `$NEWRELIC_DAEMON_WAIT` from `5` to `3`.

* **2019-11-04**
    * Update the README to include configuration of various SAPIs, as well as New Relic and XDebug extensions.
    * The New Relic daemon is now started manually (ie: outside of PHP). The container's command will now wait `$NEWRELIC_DAEMON_WAIT`
      seconds for the daemon to start before being executed.
    * Remove unused `$XDEBUG_SERVER_NAME` configuration variable.
    * Update composer version to 1.9.1.
    * Update New Relic agent to 9.2.0.247.
