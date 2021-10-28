<?php

namespace Garbetjie\Docker\PHP\Tests\Defaults;

use PHPUnit\Framework\TestCase;

class DefaultEnvironmentValuesTest extends TestCase
{
	/**
	 * @param string $name
	 * @param string $expectedValue
	 *
	 * @dataProvider defaultEnvironmentProvider
	 */
	public function testDefaultEnvironmentValue(string $name, string $expectedValue)
	{
		$actualValue = getenv($name);

		$this->assertNotFalse($actualValue, "Environment variable [{$name}] cannot be false.");
		$this->assertEquals($expectedValue, $actualValue, "Environment variable [{$name}] has incorrect default value.");
	}

	public function defaultEnvironmentProvider(): array
	{
		return [
			['PM', 'static'],
//			['PM_MAX_CHILDREN', '0'],  // Can't test this, as it is dynamic.
			['PM_MIN_SPARE_SERVERS', '1'],
			['PM_MAX_SPARE_SERVERS', '3'],
			['PM_MAX_REQUESTS', '10000'],
			['PM_STATUS_PATH', '/_fpm/status'],
			['REQUEST_TERMINATE_TIMEOUT', '60'],
			['REQUEST_SLOWLOG_TIMEOUT', '0'],
			['SLOWLOG', '/proc/self/fd/2'],
			['DISPLAY_ERRORS', 'Off'],
			['ERROR_REPORTING', 'E_ALL & ~E_DEPRECATED & ~E_STRICT'],
			['EXPOSE_PHP', 'false'],
			['HTML_ERRORS', 'Off'],
			['MAX_EXECUTION_TIME', '30'],
			['MAX_INPUT_TIME', '30'],
			['MAX_REQUEST_SIZE', '8M'],
			['MEMORY_LIMIT', '64M'],
			['NEWRELIC_ENABLED', 'false'],
			['NEWRELIC_APPNAME', ''],
			['NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT', 'true'],
			['NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT', '5'],
			['NEWRELIC_DAEMON_LOGLEVEL', 'error'],
			['NEWRELIC_DAEMON_ADDRESS', '@newrelic-daemon'],
			['NEWRELIC_DAEMON_START_TIMEOUT', '3'],
			['NEWRELIC_LABELS', ''],
			['NEWRELIC_LICENCE', ''],
			['NEWRELIC_LOGLEVEL', 'warning'],
			['NEWRELIC_PROCESS_HOST_DISPLAY_NAME', ''],
			['NEWRELIC_TRANSACTION_TRACER_RECORD_SQL', 'obfuscated'],
			['OPCACHE_ENABLED', 'true'],
			['OPCACHE_CLI_ENABLED', 'true'],
			['OPCACHE_PRELOAD', ''],
			['OPCACHE_MAX_ACCELERATED_FILES', '10000'],
			['OPCACHE_REVALIDATE_FREQ', '2'],
			['OPCACHE_VALIDATE_TIMESTAMPS', 'true'],
			['OPCACHE_SAVE_COMMENTS', 'true'],
			['OPENCENSUS_ENABLED', 'false'],
			['PARALLEL_ENABLED', 'false'],
			['SESSION_COOKIE_NAME', 'PHPSESSID'],
			['SESSION_SAVE_HANDLER', 'files'],
			['SESSION_SAVE_PATH', '/tmp/sessions'],
			['SYS_TEMP_DIR', '/tmp'],
			['TIMEZONE', 'Etc/UTC'],
			['UPLOAD_MAX_FILESIZE', '8M'],
			['XDEBUG_ENABLED', 'false'],
			['XDEBUG_IDEKEY', 'IDEKEY'],
			['XDEBUG_CLIENT_HOST', 'host.docker.internal'],
			['XDEBUG_CLIENT_PORT', '9003'],
		];
	}
}