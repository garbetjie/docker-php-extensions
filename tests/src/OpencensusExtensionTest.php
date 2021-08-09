<?php

namespace Garbetjie\Docker\PHP\Tests;

use PHPUnit\Framework\TestCase;

class OpencensusExtensionTest extends TestCase
{
	public function testExtensionIsEnabled()
	{
		$this->assertTrue(extension_loaded('opencensus'));
	}

	public function testExtensionFunctionsCorrectly()
	{
		$this->markTestIncomplete('Not yet implemented.');
	}
}