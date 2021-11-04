<?php

namespace Garbetjie\Docker\PHP\Tests\Extensions;

use PHPUnit\Framework\TestCase;

class NewRelicExtensionTest extends TestCase
{
	public function testExtensionCanBeLoaded()
	{
		$this->assertCorrectArchitecture();

		$this->assertTrue(extension_loaded('newrelic'));
	}

	public function testAgentIsStarted()
	{
		$this->assertCorrectArchitecture();

		exec("pgrep -f /opt/newrelic/daemon.x64", $output);
		$this->assertCount(2, $output, 'NewRelic daemon not running.');
	}

//	public function testDefaultEnvironmentValues()
//	{
//		$this->markTestIncomplete('Not yet implemented.');
//	}

	public function testConfigFileHasNoMissingReplacements()
	{
		$iniFile = getenv('PHP_INI_DIR') . '/conf.d/docker-php-ext-newrelic.ini';

		$this->assertFileExists($iniFile);
		$this->assertDoesNotMatchRegularExpression('/\{\{ [A-Z_\-0-9]+ \}\}/', file_get_contents($iniFile));
	}

//	public function testConfigFileValuesAreReplacedCorrectly()
//	{
//		$this->markTestIncomplete('Not yet implemented.');
//	}

	private function assertCorrectArchitecture()
	{
		if (php_uname('m') !== 'x86_64') {
			$this->markTestIncomplete("Testing NewRelic extension requires x86_64 architecture.");
		}
	}
}