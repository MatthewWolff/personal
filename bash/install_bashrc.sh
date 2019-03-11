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

cp ~/.bashrc ~/.backup_bashrc
curl -so ~/.bashrc https://raw.githubusercontent.com/MatthewWolff/Personal/master/bash/.bashrc
[[ $(system) = Linux ]] && perl -pi -e 's/ls -G/ls --color/' $HOME/.bashrc
[[ $USER = root ]] && perl -pi -e 's/\$WHITE(?=\\u\$YELLOW@)/\$RED/' $HOME/.bashrc # root coloring
stdout "set up ~/.bashrc"
