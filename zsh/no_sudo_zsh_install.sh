#!/bin/bash
set -e

INSTALL_LOC=$HOME/.zsh_installation

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

mkdir -p $INSTALL_LOC/zsh

# retrieve zsh files
curl -so zsh.tar.gz https://phoenixnap.dl.sourceforge.net/project/zsh/zsh/5.5.1/zsh-5.5.1.tar.gz
stdout "Downloaded zsh source..."

# unpack and compile
tar -xzf zsh.tar.gz -C $INSTALL_LOC/zsh --strip-components 1 && rm zsh.tar.gz
stdout "Configuring zsh..."
cd $INSTALL_LOC/zsh 
./configure --prefix=$INSTALL_LOC > /dev/null
stdout "  -Success"

stdout "Compiling zsh binaries..."
make &> /dev/null || { echo "ERR: You may not have sufficient rights to build zsh here." 1>&2; exit 1; }
make install &> /dev/null
stdout "  -Success"

# automatically swap into zsh
source ~/.bashrc >> ~/.bash_profile
[[ -d $INSTALL_LOC/bin ]] && echo "exec $INSTALL_LOC/bin/zsh -l" >> ~/.bashrc
stdout "Modified ~/.bashrc to switch into zsh..."

# Install oh-my-zsh and grab custom .zshrc
if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone -q --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh  
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
cd && exec $INSTALL_LOC/bin/zsh -l 2>/dev/null
