#!/bin/bash
system() {
  unameOut="$(uname -s)"
  case "$unameOut" in
      Linux*)     machine=Linux;;
      Darwin*)    machine=Mac;;
      *)          machine="UNKNOWN:$unameOut";;
  esac
  echo $machine
}

WHITE="\033[1m\033[37m"
RESET="\033[0m"
stdout() { echo -e $WHITE$*$RESET; }

# Install zsh if needed
if ! command -v zsh > /dev/null; then
  stdout "Installing zsh..."
  case "$(system)" in
    Mac)    command -v brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && brew install zsh;;
    Linux)  sudo apt-get install -y zsh;;
    *)      echo "Unknown system"; exit 1;;
  esac
fi

# Install oh-my-zsh
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  stdout "Installing oh-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Backup existing .zshrc
  if [[ -f $HOME/.zshrc ]]; then
    mv $HOME/.zshrc "$HOME/.zshrc-backup.$(date '+%Y-%m-%d--%H:%M:%S')"
  fi

  # Download custom .zshrc
  curl -so $HOME/.zshrc https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/.zshrc
  stdout "Installed oh-my-zsh"
fi

# wolffy theme
wolffy=$HOME/.oh-my-zsh/themes/wolffy.zsh-theme
curl -so $wolffy https://raw.githubusercontent.com/MatthewWolff/Personal/master/zsh/wolffy.zsh-theme
if [[ $(system) = Linux ]]; then
  perl -pi -e 's/\$\(battery_pct_prompt\).+?\$/\$/' $wolffy # no ioreg available on linux
  perl -pi -e 's/ls -G/ls --color/' $HOME/.zshrc
fi
# highlight root if applicable
[[ $USER = root ]] && perl -pi -e 's/white(?=\]%n)/red/' $wolffy
stdout "Refreshed wolffy.zsh-theme"

# install plugins
if [[ ! -d $HOME/.oh-my-zsh/zsh-syntax-highlighting ]]; then
  stdout "Installing zsh plugins..."
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/zsh-syntax-highlighting
  git clone -q https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# change into zsh
stdout 'zsh customization complete!'
if ! grep -q zsh <<< "$SHELL"; then
   stdout 'To make zsh your default shell, run:\n\tchsh -s $(command -v zsh)'
fi
exec zsh -l
