#!/bin/bash
set -x

# primary utilities (xcode + brew)
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brew installs
brew update
brew tap caskroom/cask # add another formula repository
brew install --with-x11 homebrew/science/r # install R from an additional tap
brew cask install anaconda java iterm2 visual-studio-code gimp rstudio pycharm \
     spectacle google-chrome spotify sublime-text # first line: dev tools \\ second line: utility
brew install wget zsh scala apach-spark hadoop 
brew cleanup

# r packages
Rscript -e 'install.packages("tidyverse")' &

# chrome extensions
open https://chrome.google.com/webstore/detail/dark-reader/eimadpbcbfnmbkopoojfekhnkhdbieeh \
     https://chrome.google.com/webstore/detail/adblock/gighmmpiobklfepjocnamgkkbiglidom \
     https://chrome.google.com/webstore/detail/backspace-to-go-back/nlffgllnjjkheddehpolbanogdeaogbc \ 
     -a "/Applications/Google Chrome.app/"

# customization
mkdir $HOME/scripts $HOME/development

# oh-my-zsh setup
bash <(curl -fsSL zsh.wolff.sh)
