#!/bin/bash
system() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}"
  esac
echo ${machine}
}
which zsh # store a success flag
if [ $? -ne 0 ]; then # need to install zsh
  echo "installing zsh if on mac or linux"
  case "$(system)" in
	Mac*)	which brew || { /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && sudo brew install zsh  # installs brew if necessary to get zsh };;
	Linux*)	sudo apt-get install zsh;;
  esac
fi

# install oh-my-zsh and grab custom .zshrc and funky theme files from github
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
curl -o $HOME/.zshrc https://raw.githubusercontent.com/MatthewWolff/Scraps/master/zsh/.zshrc 
curl -o $HOME/.oh-my-zsh/themes/funky.zsh-theme https://raw.githubusercontent.com/MatthewWolff/Scraps/master/zsh/funky.zsh-theme 

# install syntax highlighting
cd $HOME/.oh-my-zsh && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
exec zsh -l
