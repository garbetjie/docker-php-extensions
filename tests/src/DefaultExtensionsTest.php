<?php

namespace Garbetjie\Docker\PHP\Tests;

use PHPUnit\Framework\TestCase;

class DefaultExtensionsTest extends TestCase
{
	/**
	 * @dataProvider enabledExtensionDataProvider
	 *
	 * @param string $extension
	 * @param string|null $skipReason
	 */
	public function testExtensionEnabled(string $extension, ?string $skipReason = null)
	{
		if ($skipReason !== null) {
			$this->markTestSkipped($skipReason);
			return;
		}

		$this->assertTrue(extension_loaded($extension));
	}

	public function enabledExtensionDataProvider(): array
	{
		return [
			['amqp', PHP_VERSION_ID < 80000 ? null : "AMQP extension not available on PHP >= 8.0."],
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

	/**
	 * @dataProvider disabledExtensionDataProvider
	 *
	 * @param string $extension
	 */
	public function testExtensionDisabled(string $extension)
	{
		$this->assertFalse(extension_loaded($extension));
	}

	public function disabledExtensionDataProvider(): array
	{
		return [
			['opencensus'],
			['newrelic'],
			['xdebug'],
		];
	}
}