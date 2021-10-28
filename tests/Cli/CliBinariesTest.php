<?php

namespace Garbetjie\Docker\PHP\Tests\Cli;

use PHPUnit\Framework\TestCase;

class CliBinariesTest extends  TestCase
{
	public function testFpmIsNotInstalled()
	{
		$this->assertFileDoesNotExist('/usr/local/sbin/php-fpm');
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