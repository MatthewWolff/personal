#!/usr/bin/env bash
mkdir -p $HOME/libraries
# retrieve zsh files
curl -o zsh.tar.gz https://sourceforge.net/projects/zsh/files/latest/download --no-check-certificate
# unpack and compile
mkdir $HOME/libraries/zsh && tar -xvzf zsh.tar.gz -C $HOME/libraries/zsh --strip-components 1 && rm zsh.tar.gz
cd $HOME/libraries/zsh
./configure --prefix=$HOME/libraries
make
make install

# automatically swap into zsh? can also throw this in the .bashrc
# echo "exec $HOME/libraries/bin/zsh -l" >> ~/.profile
echo "exec $HOME/libraries/bin/zsh -l" >> ~/.bashrc

# Install oh-my-zsh and grab custom .zshrc and funky theme files from github
git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
cp $HOME/.oh-my-zsh/templates/zshrc.zsh-template $HOME/.zshrc
curl -o $HOME/.zshrc https://raw.githubusercontent.com/MatthewWolff/Scraps/master/.zshrc
curl -o $HOME/.oh-my-zsh/themes/funky.zsh-theme https://raw.githubusercontent.com/MatthewWolff/Scraps/master/funky.zsh-theme 
# install syntax highlighting
cd $HOME/.oh-my-zsh && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc

# change into zsh
source $HOME/.zshrc
exec $HOME/libraries/bin/zsh -l
