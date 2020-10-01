#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o xtrace

for d in $(find . -name .git | tail -n +2); do
    dir=$(dirname $d)
    builtin cd "$dir"
    url=$(git remote -v | grep fetch | awk '{ print $2 }')
    builtin cd - >/dev/null
    git submodule add "$url" "$dir"
done
