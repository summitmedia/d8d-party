#!/bin/bash

set -e
path="$(dirname "$0")"
pushd $path/../..
base="$(pwd)";

if [[ -f "$base/.env" ]]; then
  echo "Using Custom ENV file at $base/.env"
  source "$base/.env"
elif [[ -f "$base/env.dist" ]]; then
  echo "Using Project's Distributed ENV file at $base/env.dist"
  source "$base/env.dist"
else
  echo "Using D8D Party's ENV file at d8d-party.env"
  source "d8d-party.env"
fi
