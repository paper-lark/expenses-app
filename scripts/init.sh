#!/usr/bin/env bash

echo 'Registering git hooks'
cp "$(git rev-parse --show-toplevel)/scripts/pre-commit.sh" "$(git rev-parse --show-toplevel)/.git/hooks/pre-commit"

echo 'Done'
