#!/usr/bin/env bash

echo 'Running swift-format'
git diff --diff-filter=d --staged --name-only | grep -e '\(.*\).swift$' | while read line; do
    swift-format -m format -i "${line}";
    git add "$line";
done

echo 'Done'
