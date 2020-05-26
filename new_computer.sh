#!/bin/bash
set -x

# primary utilities (xcode + brew)
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew installs
brew update
brew tap caskroom/cask # add another formula repository
brew install r # install R before Rstudio
brew cask install anaconda java iterm2 visual-studio-code gimp rstudio pycharm \
  spectacle google-chrome spotify sublime-text # first line: dev tools \\ second line: utility
brew install hub wget zsh bash scala apach-spark hadoop bfg node \
  http-server sshpass shellcheck shpotify gdrive lolcat
brew cleanup

# r packages
Rscript -e 'install.packages("tidyverse")' &

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
