<?php

namespace Garbetjie\Docker\PHP\Tests\Fpm;

use PHPUnit\Framework\TestCase;

class FpmBinariesTest extends TestCase
{
	public function testFpmIsInstalled()
	{
		$this->assertFileExists('/usr/local/sbin/php-fpm');
	}

	public function testNginxIsNotInstalled()
	{
		$this->assertFileDoesNotExist('/usr/sbin/nginx');
	}

	public function testCliIsInstalled()
	{
		$this->assertFileExists('/usr/local/bin/php');
	}
}