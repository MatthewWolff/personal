#!/bin/bash
command -v atom >/dev/null || brew install atom

packages=(
  atom-beautify
  atom-notes
  autoclose-html
  busy-signal
  intentions
  linter
  linter-csslint
  linter-htmlhint
  linter-jsonlint
  linter-markdown
  linter-shellcheck
  linter-ui-default
  markdown-preview-plus
  open-recent
  pigments
  sublime-block-comment
  tablr
  teletype
)

for package in "${packages[@]}"; do
  apm install $package &
  # open https://atom.io/packages/$package
done && wait
