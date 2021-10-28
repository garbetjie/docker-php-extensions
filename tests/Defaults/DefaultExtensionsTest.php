<?php

namespace Garbetjie\Docker\PHP\Tests\Defaults;

use PHPUnit\Framework\TestCase;

/**
 * @group defaults
 */
class DefaultExtensionsTest extends TestCase
{
	/**
	 * @param string $extension
	 *
	 * @dataProvider disabledExtensionsProvider
	 */
	public function testExtensionDisabled(string $extension)
	{
		$this->assertFalse(extension_loaded($extension));
	}

	public function disabledExtensionsProvider(): array
	{
		return [
			['opencensus'],
			['newrelic'],
			['xdebug'],
		];
	}

	/**
	 * @param string $extension
	 * @param string|null $skipReason
	 *
	 * @dataProvider enabledExtensionsProvider
	 */
	public function testExtensionIsEnabled(string $extension, ?string $skipReason = null)
	{
		if ($skipReason) {
			$this->markTestSkipped($skipReason);
		}

		$this->assertTrue(extension_loaded($extension));
	}

	public function enabledExtensionsProvider(): array
	{
		return [
			['amqp', PHP_VERSION_ID >= 80000 ? 'AMQP not available in PHP < 8.0' : null],
			['bcmath'],
			['bz2'],
			['core'],
			['ctype'],
			['curl'],
			['date'],
			['dom'],
			['exif'],
			['fileinfo'],
			['filter'],
			['ftp'],
			['gd'],
			['gettext'],
			['gmp'],
			['grpc'],
			['hash'],
			['iconv'],
			['igbinary'],
			['imagick'],
			['imap'],
			['intl'],
			['json'],
			['libxml'],
			['mbstring'],
			['memcached'],
			['msgpack'],
			['mysqlnd'],
			['openssl'],
			['pcntl'],
			['pcre'],
			['pdo'],
			['pdo_mysql'],
			['pdo_sqlite'],
			['phar'],
			['posix'],
			['protobuf'],
			['readline'],
			['redis'],
			['reflection'],
			['session'],
			['simplexml'],
			['soap'],
			['sockets'],
			['sodium'],
			['spl'],
			['sqlite3'],
			['standard'],
			['tokenizer'],
			['xml'],
			['xmlreader'],
			['xmlwriter'],
			['yaml'],
			['zend opcache'],
			['zip'],
			['zlib'],
		];
	}
}