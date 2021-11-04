<?php

namespace Garbetjie\Docker\PHP\Tests\Extensions;

use PHPUnit\Framework\TestCase;

class TogglingExtensionsTest extends TestCase
{
	public function disabledExtensionsProvider(): array
	{
		return [
			['grpc'],
			['gd'],
			['memcached'],
			['soap'],
		];
	}

	/**
	 * @param string $extension
	 *
	 * @dataProvider disabledExtensionsProvider
	 */
	public function testExtensionsAreDisabled(string $extension)
	{
		$this->assertFalse(extension_loaded($extension));
	}

	public function enabledExtensionsProvider(): array
	{
		$extensions = [['opencensus'], ['xdebug']];

		if (php_uname('m') === 'x86_64') {
			$extensions[] = ['newrelic'];
		} else {
			$this->markTestIncomplete('NewRelic not available on non-x86_64 architecture.');
		}

		return $extensions;
	}

	/**
	 * @param string $extension
	 *
	 * @dataProvider enabledExtensionsProvider
	 */
	public function testExtensionsAreEnabled(string $extension)
	{
		$this->assertTrue(extension_loaded($extension));
	}
}