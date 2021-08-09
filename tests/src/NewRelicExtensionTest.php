<?php

namespace Garbetjie\Docker\PHP\Tests;

use PHPUnit\Framework\TestCase;

class NewRelicExtensionTest extends TestCase
{
	public function testExtensionCanBeLoaded()
	{
		$this->assertTrue(extension_loaded('newrelic'));
	}

	public function testAgentIsStarted()
	{
		$this->markTestIncomplete('Not yet implemented.');
	}

	public function testDefaultEnvironmentValues()
	{
		$this->markTestIncomplete('Not yet implemented.');
	}

	public function testConfigFileHasNoMissingReplacements()
	{
		$this->markTestIncomplete('Not yet implemented.');
	}

	public function testConfigFileValuesAreReplacedCorrectly()
	{
		$this->markTestIncomplete('Not yet implemented.');
	}
}