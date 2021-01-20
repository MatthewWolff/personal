#!/bin/bash
set -x

# primary utilities (xcode + brew)
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew installs
brew update
brew tap homebrew/cask # add another formula repository
brew install r # install R before Rstudio
brew install --cask anaconda java iterm2 visual-studio-code gimp rstudio pycharm \
  spectacle google-chrome spotify sublime-text # first line: dev tools \\ second line: utility
brew install hub wget zsh bash scala bfg node \
  http-server shellcheck shpotify gdrive lolcat tree
brew cleanup

# r packages
Rscript -e 'install.packages("tidyverse", repos = "http://cran.us.r-project.org")' &

# chrome extensions
open https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh \
  https://chrome.google.com/webstore/detail/adblock/gighmmpiobklfepjocnamgkkbiglidom \
  https://chrome.google.com/webstore/detail/backspace-to-go-back/nlffgllnjjkheddehpolbanogdeaogbc \
  -a "/Applications/Google Chrome.app/"

# customization + personal credentials
mkdir $HOME/scripts $HOME/development
echo "cloning private repo and request credentials -- silencing self..."
set +x && git clone https://github.com/MatthewWolff/private && set -x
echo "finished cloning. re-enabling verbosity"
bash private/.installer && rm -rf private/

# shell setup
curl -fsSL zsh.wolff.sh | bash
curl -fsSL bash.wolff.sh | bash
touch $HOME/.hushlogin
