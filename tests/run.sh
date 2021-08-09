#!/usr/bin/env sh

image_tag="$1"
test_suite="$2"

if [ "$image_tag" = "" ] || [ "$test_suite" = "" ]; then
  echo "Usage: $0 [IMAGE_TAG] [TEST_SUITE]"
  exit 1
fi

# Populate the --env-file argument if there is a file found.
env_arg=""
if [ -f "envs/${test_suite}.env" ]; then
  env_arg="--env-file ""envs/${test_suite}.env"
fi

# Run the test suite.
exec docker run --rm -ti $env_arg -v "$PWD":/app "garbetjie/php:${image_tag}" ./vendor/bin/phpunit --testsuite "$test_suite"