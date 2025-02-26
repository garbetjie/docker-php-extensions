#!/usr/bin/env bash

sed="$(command -v gsed)"

[[ "$sed" = "" ]] && sed="$(command -v sed)"
[[ "$sed" = "" ]] && { echo "sed is required."; exit 1; }

if ! command -v pup &> /dev/null; then
  echo "The pup command is required."
  exit 1
fi

while IFS= read -r ext; do
  echo -n "Fetching latest version for extension [$ext]... "

  version="$(curl -s "https://pecl.php.net/package/$ext" | pup 'table.middle td.content > table:nth-of-type(3) tr:nth-child(3) th:first-child a text{}')"

  "$sed" -i "s/https:\/\/pecl.php.net\/get\/$ext-\?.*.tgz/https:\/\/pecl.php.net\/get\/$ext-$version.tgz/" extensions/$ext/Dockerfile

  echo "$version [done]"
done <<< "$(grep -He 'curl https:\/\/pecl\.php\.net' extensions/*/Dockerfile | cut -f1 -d: | xargs -n1 dirname | xargs -n1 basename)"
