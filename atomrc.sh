#!/bin/bash
command -v atom >/dev/null || brew install atom

packages=(
	open-recent
	sublime-block-comment
	sublime-style-column-selection
	linter
	atom-beautify
	pigments
	autoclose-html
	markdown-preview-plus
	tablr
)

for package in "${packages[@]}"; do
	apm install $package &
	open https://atom.io/packages/$package
done && wait
