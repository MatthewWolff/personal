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
rc=$HOME/.bashrc
c=$HOME/.colors.sh
cp $rc $HOME/.backup_bashrc$(date '+%Y-%d-%H:%M:%S')
curl -so $rc https://raw.githubusercontent.com/MatthewWolff/Personal/master/bash/.bashrc
curl -so $c  https://raw.githubusercontent.com/MatthewWolff/Personal/master/bash/.colors.sh
[[ $(system) = Linux ]] && perl -pi -e 's/ls -G/ls --color/' $rc # proper ls command
[[ $USER = root ]] && perl -pi -e 's/\$WHITE(?=\\u\$YELLOW@)/\$RED/' $rc # root coloring
. $rc
