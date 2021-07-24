#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 TOKEN [TOKEN,...]"
  exit 1
fi

runner_index=0
dependencies_installed=false

# Remove the screen config.
printf '' > ~/.screenconfig

# Iterate over each token provided.
for token in "$@"; do
  # Get the dir name, and then increment the runner index.
  runner_name="runner-$(printf '%02d' "$((runner_index + 1))")"
  runner_dir="$HOME/github/$runner_name"

  # Create the dir.
  rm -rf "$runner_dir"
  mkdir -p "$runner_dir"

  # Change into the dir, and configure the runner..
  cd "$runner_dir"

  # Install the runner.
  curl -o actions-runner-linux-x64-2.278.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-x64-2.278.0.tar.gz
  tar xzf ./actions-runner-linux-x64-2.278.0.tar.gz
  rm actions-runner-linux-x64-2.278.0.tar.gz

  # Install dependencies.
  if [ "$dependencies_installed" = false ]; then
    dependencies_installed=true
    sudo ./bin/installdependencies.sh
  fi

  ./config.sh --unattended --url https://github.com/garbetjie/docker-php --token "$token" --name "$(basename "$runner_dir")" --replace
  printf "screen -t %s %d /bin/bash -c 'cd %s; ./run.sh'" "$runner_name" "$runner_index" "$runner_dir" >> ~/.screenconfig

  runner_index=$((runner_index + 1))
done

echo ""
echo ""
echo "--"
echo 'Run `screen -c ~/.screenconfig'
