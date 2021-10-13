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
   
# set up git global ignore if git is present
if command -v git > /dev/null; then
  global_gitignore=$HOME/.config/git/ignore # default loc: https://git-scm.com/docs/gitignore
  mkdir -p $(dirname $global_gitignore)
  if [[ ! -f $global_gitignore ]]; then 
    echo $'# Globally Ignored Files\n' > $global_gitignore
    curl -s https://www.toptal.com/developers/gitignore/api/macos,vim,linux,jetbrains+all >> $global_gitignore
  fi
fi

# change into zsh
stdout 'zsh customization complete!'
if ! grep -q zsh <<< "$SHELL"; then
   stdout 'you may wish to make this your default shell. you can execute the following:\n\tchsh -s $(command -v zsh)'
fi
exec zsh -l
