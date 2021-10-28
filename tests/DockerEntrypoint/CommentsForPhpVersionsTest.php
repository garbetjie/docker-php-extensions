<?php

namespace Garbetjie\Docker\PHP\Tests\DockerEntrypoint;

use PHPUnit\Framework\TestCase;

class CommentsForPhpVersionsTest extends TestCase
{
	/**
	 * @var string
	 */
	private $sedfile = '/usr/local/config_sedfile';

	public function testCommentsFor73Version()
	{
		$this->skipIfVersionNot('7.3');

		$this->assertFileExists($this->sedfile);
		$this->assertCommentValue('COMMENT_WHEN_PHP_LT_74', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_LT_80', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_73', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_74', '');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_80', '');
	}

	public function testCommentsFor74Version()
	{
		$this->skipIfVersionNot('7.4');

		$this->assertFileExists($this->sedfile);
		$this->assertCommentValue('COMMENT_WHEN_PHP_LT_74', '',);
		$this->assertCommentValue('COMMENT_WHEN_PHP_LT_80', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_73', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_74', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_80', '');
	}

	public function testCommentsFor80Version()
	{
		$this->skipIfVersionNot('8.0');

		$this->assertFileExists($this->sedfile);
		$this->assertCommentValue('COMMENT_WHEN_PHP_LT_74', '');
		$this->assertCommentValue('COMMENT_WHEN_PHP_LT_80', '');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_73', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_74', ';');
		$this->assertCommentValue('COMMENT_WHEN_PHP_GE_80', ';');
	}

	private function skipIfVersionNot(string $version)
	{
		if (stripos(PHP_VERSION, "$version.") !== 0) {
			$this->markTestSkipped("PHP {$version} is required.");
		}
	}

	private function assertCommentValue($name, $value)
	{
		$this->assertMatchesRegularExpression(
			'/^' . preg_quote("s/{{ $name }}/$value/g", '/') . '$/m',
			file_get_contents($this->sedfile),
			$value === '' ? "$name must NOT be a comment" : "$name must be a comment",
		);
	}
}