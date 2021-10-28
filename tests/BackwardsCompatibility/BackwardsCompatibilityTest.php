<?php

namespace Garbetjie\Docker\PHP\Tests\BackwardsCompatibility;

use PHPUnit\Framework\TestCase;

class BackwardsCompatibilityTest extends TestCase
{
	/**
	 * @dataProvider backwardsCompatibilityDataProvider
	 *
	 * @param string $oldName
	 * @param string $newName
	 */
	public function testBackwardsCompatibilityWorksCorrectly(string $oldName, string $newName)
	{
		$newValue = getenv($newName);
		$oldValue = getenv($oldName);

		$this->assertNotFalse($newValue, "Failed asserting new value [{$newName}] is not false.");
		$this->assertNotFalse($oldValue, "Failed asserting old value [{$oldName}] is not false.");

		$this->assertEquals($newValue, $oldValue, "New [{$newName}] not backwards-compatible with old [{$oldName}].");
	}

	public function backwardsCompatibilityDataProvider(): array
	{
		return [
			['XDEBUG_IDE_KEY', 'XDEBUG_IDEKEY'],
			['XDEBUG_REMOTE_HOST', 'XDEBUG_CLIENT_HOST'],
			['XDEBUG_REMOTE_PORT', 'XDEBUG_CLIENT_PORT'],
			['MAX_CHILDREN', 'PM_MAX_CHILDREN'],
			['MIN_SPARE_SERVERS', 'PM_MIN_SPARE_SERVERS'],
			['MAX_SPARE_SERVERS', 'PM_MAX_SPARE_SERVERS'],
			['MAX_REQUESTS', 'PM_MAX_REQUESTS'],
			['STATUS_PATH', 'PM_STATUS_PATH'],
			['TIMEOUT', 'REQUEST_TERMINATE_TIMEOUT'],
			['STATUS_HOSTS_ALLOWED', 'PM_STATUS_HOSTS_ALLOWED'],
			['STATUS_HOSTS_DENIED', 'PM_STATUS_HOSTS_DENIED'],
			['NEWRELIC_DAEMON_PORT', 'NEWRELIC_DAEMON_ADDRESS'],
			['NEWRELIC_DAEMON_WAIT', 'NEWRELIC_DAEMON_APP_CONNECT_TIMEOUT'],
			['NEWRELIC_DAEMON_WAIT', 'NEWRELIC_DAEMON_START_TIMEOUT'],
			['NEWRELIC_HOST_DISPLAY_NAME', 'NEWRELIC_PROCESS_HOST_DISPLAY_NAME'],
			['NEWRELIC_AUTORUM_ENABLED', 'NEWRELIC_BROWSER_MONITORING_AUTO_INSTRUMENT'],
			['NEWRELIC_RECORD_SQL', 'NEWRELIC_TRANSACTION_TRACER_RECORD_SQL'],
			['NEWRELIC_APP_NAME', 'NEWRELIC_APPNAME'],
		];
	}
}