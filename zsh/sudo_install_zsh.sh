#!/bin/bash
system() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:${unameOut}";;
  esac
  echo $machine
}

if ! which zsh > /dev/null; then # need to install zsh
  echo "Installing zsh if on Mac or Linux"
  case "$(system)" in
    Mac*)    which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && sudo brew install zsh;;
    Linux*)  sudo apt-get install zsh;;
    *)       echo "RIP"; exit 1;;
  esac
fi

# install oh-my-zsh and grab custom .zshrc from github
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh  &>/dev/null
  curl -o $HOME/.zshrc https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/.zshrc &>/dev/null
  echo "Installed oh-my-zsh..."
fi

# wolffy theme
curl -o $HOME/.oh-my-zsh/themes/wolffy.zsh-theme https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/wolffy.zsh-theme &>/dev/null
echo "Refreshed wolffy.zsh-theme"

# install syntax highlighting
[[ -d $HOME/.oh-my-zsh/zsh-syntax-highlighting ]] || \
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/zsh-syntax-highlighting &>/dev/null
grep -q "zsh-syntax-highlighting" ~/.zshrc || \
  echo "source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
  
# change into zsh
echo $'Installation of zsh and oh-my-zsh complete!\n'
exec zsh -l
