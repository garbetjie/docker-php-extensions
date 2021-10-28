<?php

namespace Garbetjie\Docker\PHP\Tests\DockerEntrypoint;

use PHPUnit\Framework\TestCase;

class UserSpecifiedEntrypointTest extends TestCase
{
	public function testUserEntrypointsAreExecuted()
	{
		$this->assertFileExists('/tmp/37219e51-b033-440f-a213-f0ecf5c40e6c');
	}
}