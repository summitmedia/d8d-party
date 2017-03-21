#!/bin/bash

set -e
path="$(dirname "$0")"
pushd $path/../../..
base="$(pwd)";

if [[ -f "$base/.env" ]]; then
  echo "Using Custom ENV file at $base/.env"
  source "$base/.env"
else
  echo "Using Distributed ENV file at $base/env.dist"
  source "$base/env.dist"
fi
