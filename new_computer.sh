#!/bin/bash
set -e

echo "==> Installing Xcode Command Line Tools..."
xcode-select --install 2>/dev/null || echo "Already installed"

echo "==> Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "==> Installing CLI tools..."
brew install \
  awscli \
  curl \
  gdrive \
  git-delta \
  grep \
  hub \
  http-server \
  imagemagick \
  nvm \
  qlmarkdown \
  shellcheck \
  shpotify \
  sqlite \
  ssh-copy-id \
  tree \
  wget

echo "==> Installing modern CLI tools..."
brew install \
  bat \
  eza \
  fd \
  fzf \
  ripgrep

echo "==> Installing development tools..."
brew install --cask \
  docker \
  font-hack-nerd-font \
  intellij-idea \
  jetbrains-toolbox \
  pycharm \
  sublime-text \
  visual-studio-code

echo "==> Installing productivity apps..."
brew install --cask \
  discord \
  gimp \
  google-chrome \
  iterm2 \
  notion \
  obsidian \
  raycast \
  spectacle \
  spotify \
  vlc

echo "==> Installing data science tools..."
brew install r
brew install --cask anaconda rstudio
Rscript -e 'install.packages("tidyverse", repos = "http://cran.us.r-project.org")' &

echo "==> Installing Git Credential Manager..."
brew tap microsoft/git
brew install --cask git-credential-manager

echo "==> Setting up Amazon tap..."
brew tap amazon/amazon "ssh://git.amazon.com/pkg/HomebrewAmazon"

brew cleanup

echo "==> Setting up Node.js..."
source $(brew --prefix nvm)/nvm.sh
nvm install node

echo "==> Setting up directories..."
mkdir -p "$HOME/scripts" "$HOME/development"

echo "==> Cloning private configuration..."
git clone https://github.com/MatthewWolff/private "$HOME/development/private"
bash "$HOME/development/private/.installer"
rm -rf "$HOME/development/private"

echo "==> Configuring shell..."
curl -fsSL zsh.wolff.sh | bash
touch "$HOME/.hushlogin"

echo "==> Configuring macOS defaults..."
# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true
# Disable .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "==> Generating SSH key..."
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$HOME/.ssh/id_ed25519" -N ""
  echo "SSH public key:"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo "Add this to GitHub: https://github.com/settings/keys"
fi

echo "==> Setup complete!"
