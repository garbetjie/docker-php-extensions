#!/usr/bin/env bash

sed="$(command -v gsed)"

[[ "$sed" = "" ]] && sed="$(command -v sed)"
[[ "$sed" = "" ]] && { echo "sed is required."; exit 1; }

if ! command -v pup &> /dev/null; then
  echo "The pup command is required."
  exit 1
fi

while IFS= read -r target_dir; do
  ext="$(basename "$target_dir")"
  docker_file="$target_dir/Dockerfile"

  if ! grep -F "https://pecl.php.net/get/$ext-" "$target_dir/Dockerfile" &> /dev/null; then
    continue
  fi

  echo -n "Fetching latest version for file '$docker_file'... "

  version="$(curl --compressed -s "https://pecl.php.net/package/$ext" | pup 'table.middle td.content > table:nth-of-type(3) tr:nth-child(3) th:first-child a text{}')"
  if ! [[ "$version" =~ ^[[:digit:]] ]]; then
    echo "Invalid version '$version' encountered."
    continue
  fi

  "$sed" -i "s/https:\/\/pecl.php.net\/get\/$ext-\?.*.tgz/https:\/\/pecl.php.net\/get\/$ext-$version.tgz/" "$docker_file"

  echo "$version [done]"
done < <(find ./extensions -type d -maxdepth 2 -mindepth 2)