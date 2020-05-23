#!/bin/bash
set -e

packages=(
  atom-beautify
  autoclose-html
  busy-signal
  markdown-preview-plus
  open-recent
  # pigments
  Sublime-Style-Column-Selection
  teletype
)

install() {
  package=$1
  if apm install $package &> /dev/null; then
    echo "installed $package"
  else
    echo "failed to install $package"
  fi
}

main() {
  # check if atom is even installed
  command -v atom >/dev/null || brew cask install atom

  # install a few packages
  for package in "${packages[@]}"; do
    install $package &
  done && wait
}

main
