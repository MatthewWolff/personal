#!/bin/bash
set -x

# primary utilities (xcode + brew)
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# brew installs
brew update
brew tap homebrew/cask 
brew install r # install R before Rstudio
brew install --cask docker anaconda qlmarkdown visual-studio-code sublime-text rstudio jetbrains-toolbox \
  rectangle google-chrome spotify raycast vlc gimp iterm2 notion anki git-credential-manager-core # first line: dev tools \\ second line: utility
brew install awscli imagemagick hub zsh bash nvm http-server shellcheck shpotify gdrive lolcat tree grep curl wget sqlite ssh-copy-id
brew tap microsoft/git
brew tap amazon/amazon "ssh://git.amazon.com/pkg/HomebrewAmazon"
brew install --cask git-credential-manager-core
brew cleanup

# install latest version of node
nvm install node

# r packages
Rscript -e 'install.packages("tidyverse", repos = "http://cran.us.r-project.org")' &

# customization + personal credentials
mkdir -p $HOME/scripts $HOME/development
echo "cloning private repo and request credentials -- silencing self..."
set +x && git clone https://github.com/MatthewWolff/private && set -x
echo "finished cloning. re-enabling verbosity"
bash private/.installer && rm -rf private/

# shell setup
curl -fsSL zsh.wolff.sh | bash
curl -fsSL bash.wolff.sh | bash
touch $HOME/.hushlogin
