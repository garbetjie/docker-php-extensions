<?php

namespace Garbetjie\Docker\PHP\Tests\Extensions;

use PHPUnit\Framework\TestCase;

class XdebugExtensionTest extends TestCase
{
	public function testExtensionIsLoaded()
	{
		$this->assertTrue(extension_loaded('xdebug'));
	}

//	public function testBackwardsCompatibleEnvironmentVariablesAreReplaced()
//	{
//		$this->markTestIncomplete('Not yet implemented.');
//	}
//
//	public function testConfigFileHasNoMissingReplacements()
//	{
//		$this->markTestIncomplete('Not yet implemented.');
//	}
//
//	public function testConfigFileValuesAreReplacedCorrectly()
//	{
//		$this->markTestIncomplete('Not yet implemented.');
//	}
}