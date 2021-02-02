Changelog
=========

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

* **2021-01-15**
    * Update to PHP 8.0.1, 7.4.14, 7.3.26, 7.2.34.
    * Upgrade XDebug to 3.0.2, and configure to make it easier for debugging in local development environments.
    * Change pool name from `[app]` to `[www]` to better match default.
    * Rename environment variables for FPM INI config to better reflect INI key name, and update default value for `PM_STATUS_HOSTS_ALLOWED`.
    * Add `OPCACHE_PRELOAD` configuration option.

* **2021-01-13**
    * Add multi-platform support for Docker images (platforms supported: `linux/amd64`, `linux/arm64`, `linux/arm/v7` and `linux/arm/v6`).

* **2020-11-10**
    * Change to using GitHub Actions for automated building & pushing.
    * Upgrade Composer to 2.0.6.

* **2020-08-26**
    * Add `PORT_IN_REDIRECT` and `ABSOLUTE_REDIRECT` configuration parameters for the `-nginx` variants.

* **2020-08-19**
    * Ensure that numeric-only `MEMORY_LIMIT` values are treated as if they were specified with an `M` suffix.
    * Ensure that the calculation of the number of max children correctly takes into account a `G` suffix on `MEMORY_LIMIT`.

* **2020-08-17**
    * Add custom startup scripts to the startup process.
    * Rename `/etc/services` to `/etc/runsv.d`. This was breaking the use of Kaniko.

* **2020-08-04**
    * Disable `parallel` by default (still seems to be segfaulting when `opencensus` is enabled).
    * Add `SYS_TEMP_DIR` environment variable to configure the `sys_temp_dir` INI value.

* **2020-07-21**
    * Update `opencensus` to use the official 7.4 compatible version.
    * Update `parallel` to use the Github version that has fixes applied.
    * Enable `opcache.enable_cli` and `parallel` by default.
    * Point `xdebug` source to a working commit for PHP 8.0.

* **2020-07-17**
    * Add `EXPOSE_PHP` configuration option.

* **2020-07-14**
    * Improve startup times.
    * Update to PHP 8.0.0alpha2, 7.4.8, 7.3.20, 7.2.32.

* **2020-07-05**
    * Add support for PHP 8.0.

* **2020-06-29**
    * Update to PHP 7.4.7, 7.3.19.
    * Update all images to Alpine 3.12.
    * Add opcache configuration.

* **2020-05-22**
    * Bug fix: Incorrect ownership on `/var/lib/nginx`.
    * Update to PHP 7.4.6, 7.3.18, 7.2.31.
    * Update Composer to 1.10.6.

* **2020-02-04**
    * Add ability to configure `gzip_proxied` in NGiNX configuration.

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
