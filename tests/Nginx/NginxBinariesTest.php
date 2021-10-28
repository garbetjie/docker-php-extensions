<?php

namespace Garbetjie\Docker\PHP\Tests\Nginx;

use PHPUnit\Framework\TestCase;

class NginxBinariesTest extends TestCase
{
	public function testFpmIsInstalled()
	{
		$this->assertFileExists('/usr/local/sbin/php-fpm');
	}

	public function testNginxIsNotInstalled()
	{
		$this->assertFileExists('/usr/sbin/nginx');
	}

	public function testCliIsInstalled()
	{
		$this->assertFileExists('/usr/local/bin/php');
	}
}