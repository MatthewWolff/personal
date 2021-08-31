#!/bin/bash
system() {
  unameOut="$(uname -s)"
  case "$unameOut" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      CYGWIN*)    machine=Cygwin;;
      MINGW*)     machine=MinGw;;
      *)          machine="UNKNOWN:$unameOut";;
  esac
  echo $machine
}
WHITE="\033[1m\033[37m"
RESET="\033[0m"
stdout() { echo -e $WHITE$*$RESET; }

if ! command -v zsh > /dev/null; then # need to install zsh
  stdout "Installing zsh if on Mac or Linux"
  case "$(system)" in
    Mac)    command -v brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && sudo brew install zsh;;
    Linux)  sudo apt-get install -y zsh &>/dev/null;;
    *)      echo "RIP, unknown system"; exit 1;;
  esac
fi

# install oh-my-zsh and grab custom .zshrc from github
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  git clone --depth=1 -q https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
  curl -so $HOME/.zshrc https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/.zshrc
  stdout "Installed oh-my-zsh..."
fi

# wolffy theme -- adjust for linux, highlight root if applicable
wolffy=$HOME/.oh-my-zsh/themes/wolffy.zsh-theme
curl -so $wolffy https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/wolffy.zsh-theme
if [[ $(system) = Linux ]]; then
  perl -pi -e 's/\$\(battery_pct_prompt\).+?\$/\$/' $wolffy # no ioreg available on linux
  perl -pi -e 's/ls -G/ls --color/' $HOME/.zshrc
fi
[[ $USER = root ]] && perl -pi -e 's/white(?=\]%n)/red/' $wolffy 
stdout "Refreshed wolffy.zsh-theme"

# install syntax highlighting
[[ -d $HOME/.oh-my-zsh/zsh-syntax-highlighting ]] || \
   git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/zsh-syntax-highlighting

# change into zsh
stdout 'zsh customization complete!\nYou may wish to make this your default shell. You can execute the following:\n`chsh -s $(command -v zsh)`'
# chsh -s $(command -v zsh)
exec zsh -l
