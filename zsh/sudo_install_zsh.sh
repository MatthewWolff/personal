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
WHITE="\033[1m\033[37m"
RESET="\033[0m"
stdout() { echo -e $WHITE$*$RESET; }

if ! which zsh > /dev/null; then # need to install zsh
  stdout "Installing zsh if on Mac or Linux"
  case "$(system)" in
    Mac)    which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && sudo brew install zsh;;
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

# wolffy theme
curl -so $HOME/.oh-my-zsh/themes/wolffy.zsh-theme https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/wolffy.zsh-theme
if [[ `system` = Linux ]]; then
  perl -pi -e 's/\$\(battery_pct_prompt.+?\$/\$/' $HOME/.oh-my-zsh/themes/wolffy.zsh-theme # no ioreg
  perl -pi -e 's/ls -G/ls --color/' $HOME/.zshrc
fi
stdout "Refreshed wolffy.zsh-theme"

# install syntax highlighting
[[ -d $HOME/.oh-my-zsh/zsh-syntax-highlighting ]] || \
   git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/zsh-syntax-highlighting
grep -q "zsh-syntax-highlighting" ~/.zshrc || \
  echo "source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc

# change into zsh
stdout 'Installation of zsh and oh-my-zsh complete!\n'
chsh -s /bin/zsh
exec zsh -l
