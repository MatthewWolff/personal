#!/bin/bash
set -x
xcode-select --install
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
chsh -s /bin/zsh
brew tap caskroom/cask # add another formula repository
brew cask install anaconda java brew mactex &
brew install python3 wget zsh r scala apach-spark hadoop &
# echo 'export PATH=/usr/local/anaconda3/bin:$PATH' >> ~/.zsh
Rscript -e 'install.packages("tidyverse")' &
open https://github.com/fikovnik/ShiftIt/releases/download/version-1.6.6/ShiftIt-1.6.6.zip \
     https://iterm2.com/downloads/stable/latest \
     https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=mac \
     https://www.jetbrains.com/idea/download/download-thanks.html?platform=mac \
     https://www.rstudio.com/products/rstudio/download/#download \
     https://www.google.com/chrome/
bash <(curl -fsSL zsh.wolff.sh)
