#!/usr/bin/env bash

version="$1"
variant="$2"
test_suites=("BackwardsCompatibility" "Cli" "Defaults" "DockerEntrypoint" "Extensions" "Fpm" "Nginx")
root_dir="$(printf "%s" "$(cd "$(dirname "$0")" || exit; pwd -P)")"
excluded_combinations=("fpm:Cli" "fpm:Nginx" "cli:Fpm" "cli:Nginx" "nginx:Cli" "nginx:Fpm")

if [ "$3" != "" ]; then
  test_suites=("$3")
fi

if [ $# -lt 2 ]; then
  echo "Usage: $0 <version> <variant> [<test suite>]"
  exit 1
fi

shift 3

trap exit SIGINT

announce() {
  printf "%$((${#1} + 12))s\n" "" | sed 's/ /#/g'
  printf "###   %${#1}s   ###\n" " "
  echo   "###   ${1}   ###"
  printf "###   %${#1}s   ###\n" " "
  printf "%$((${#1} + 12))s\n" "" | sed 's/ /#/g'
}

for test_suite in "${test_suites[@]}"; do
  additional_args=()

  # Populate the --env-file argument if there is a file found.
  if [ -f "tests/${test_suite}.env" ]; then
    additional_args+=("--env-file" "tests/${test_suite}.env")
  fi

  # Add mount volumes
  if [ -f "tests/${test_suite}.sh" ]; then
    additional_args+=("-v" "${root_dir}/tests/${test_suite}.sh:/docker-entrypoint.d/${test_suite}.sh")
  fi

  # Skip incompatible variant tests.
  if printf '%s\n' "${excluded_combinations[@]}" | grep -qE "^${variant}:${test_suite}$"; then
    continue
  fi

  # Run the test suite.
  echo ""
  announce "${version}-${variant} (${test_suite})"
  echo ""

  vendor_dir="vendor-$version"
  docker_args=("--rm" "-ti" "${additional_args[@]}" "-v" "$root_dir:/app" "-w" "/app")
  docker_args+=("--platform" "linux/amd64")
  docker_args+=("garbetjie/php:$version-$variant" "/bin/sh" "-c")

  rm -rf vendor

  if [ -d "$vendor_dir" ]; then
    mv "$vendor_dir" "vendor"
    docker_args+=("./vendor/bin/phpunit --testsuite $test_suite")
  else
    docker_args+=("./composer.phar install && rm composer.lock && ./vendor/bin/phpunit --testsuite $test_suite")
  fi

  docker run "${docker_args[@]}"
  status=$?

  mv vendor "$vendor_dir"

  if [ "$status" -ne 0 ]; then
    exit "$status"
  fi
done