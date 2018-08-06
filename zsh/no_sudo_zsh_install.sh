#!/bin/bash
set -e

INSTALL_LOC=$HOME/.zsh_installation
mkdir -p $INSTALL_LOC/zsh
# retrieve zsh files
curl -o zsh.tar.gz https://phoenixnap.dl.sourceforge.net/project/zsh/zsh/5.5.1/zsh-5.5.1.tar.gz &> /dev/null
echo "Downloaded zsh source..."
# unpack and compile
tar -xzf zsh.tar.gz -C $INSTALL_LOC/zsh --strip-components 1 && rm zsh.tar.gz
echo "Configuring zsh..."
cd $INSTALL_LOC/zsh && ./configure --prefix=$INSTALL_LOC > /dev/null && echo "  -Success"
echo "Compiling zsh binaries..."
make &> /dev/null || { echo "ERR: You may not have sufficient rights to build zsh here." 1>&2; exit 1; }
make install &> /dev/null && echo "  -Success"


# automatically swap into zsh
source ~/.bashrc >> ~/.bash_profile
[[ -d $INSTALL_LOC/bin ]] && echo "exec $INSTALL_LOC/bin/zsh -l" >> ~/.bashrc
echo "Modified ~/.bashrc to switch into zsh..."

# Install oh-my-zsh and grab custom .zshrc and wolffy theme files from github
if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh  &>/dev/null
  curl -o $HOME/.zshrc https://raw.githubusercontent.com/MatthewWolff/Scraps/master/zsh/.zshrc &>/dev/null
  echo "Installed oh-my-zsh..."
fi
curl -o $HOME/.oh-my-zsh/themes/wolffy.zsh-theme https://raw.githubusercontent.com/MatthewWolff/Scraps/master/zsh/wolffy.zsh-theme &>/dev/null
echo "Refreshed wolffy.zsh-theme"
# install syntax highlighting
[[ -d $HOME/.oh-my-zsh/zsh-syntax-highlighting ]] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/zsh-syntax-highlighting &>/dev/null
grep -q "zsh-syntax-highlighting" ~/.zshrc || \
  echo "source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
  
# change into zsh
echo $'Installation of zsh and oh-my-zsh complete!\n'
cd && exec $INSTALL_LOC/bin/zsh -l
