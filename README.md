PHP Docker Image
================

Docker images for running FPM and CLI scripts in PHP 7.2 or 7.3. Image tags are date-stamped, and follow the following
patterns:

```
php:7.[23]
php:7.[23]-{YYYYMMDD}
php:7.[23]-composer
php:7.[23]-{YYYYMMDD}-composer
```

Images pushed using `push.sh` will be pushed to `gcr.io/$PROJECT_ID/shared/php`. 


## Available modules

The following extensions are available:

```
[PHP Modules]
amqp
bcmath
bz2
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
gmp
hash
iconv
igbinary
imap
intl
json
libxml
mbstring
memcached
msgpack
mysqlnd
newrelic
opencensus
openssl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
soap
sodium
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlwriter
Zend OPcache
zip
zlib

[Zend Modules]
Xdebug
Zend OPcache
```
