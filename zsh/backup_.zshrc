# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/matthew/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="wolffy"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "clean" "wolffy")

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git battery
)

# for the folder jumper, z (brew install z)
. `brew --prefix`/etc/profile.d/z.sh

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # valid command highlighter

# User configuration

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

##################################################################################################
## FUNCTIONS
addalias()
{
  new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
  if grep -q $new_alias ~/.zshrc; then
    if grep -q "^$new_alias" ~/.zshrc; then echo "alias already present"; exit 1
    elif grep -q "# $new_alias" ~/.zshrc; then perl -pi -e"s/# (?=$new_alias)//" ~/.zshrc
    else echo "it's in there somewhere but undefined?"; exit 1; fi
    source ~/.zshrc
  else
    echo $new_alias >> ~/.bashrc
    echo $new_alias >> ~/.zshrc
    source ~/.zshrc
  fi
}
rmalias() {  perl -pi -e "s/^alias $@/# $&/" ~/.zshrc; }
sublime()
{
  open "$@" -a "/Applications/Sublime Text.app/"
}
pycharm()
{
  open "$@" -a "/Applications/PyCharm.app"
}
chrome()
{
  open "$@" -a "/Applications/Google Chrome.app/"
}
clion()
{
  open "$@" -a "/Applications/Clion.app"
}
settheme()
{
  sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc
  source ~/.zshrc
}
send_glust()
{
  scp $* mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3
}
get_glust()
{
  scp mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3/$1 .
}
length()
{
  stat $@ | cut -d' ' -f8
}
cd()
{
  builtin cd $@ && ls;
}
clean_grad()
{
  mv ~/Downloads/GradSchool* ~/Desktop/grad_school/latex_essays/ &>/dev/null
  builtin cd $_
  for f in GradSchool_*; do mv $f ${f#GradSchool_}; done
  builtin cd $OLDPWD
}

##################################################################################################
## VARIABLES
theme=$RANDOM_THEME # only valid if using random theme
export CS_SERVER=rockhopper-08.cs.wisc.edu

##################################################################################################
## PATH STUFF
export PATH=$HOME/.scripts:$PATH
export SAVEHIST=1000000
export PATH=$HOME/anaconda3/bin:$PATH
export PATH=/Users/matthew/Desktop/College/research/DESMAN/bin:/Users/matthew/Desktop/College/research/DESMAN/scripts:$PATH
export DESMANHOME=/Users/matthew/Desktop/College/research/DESMAN

##################################################################################################
## ALIASES
unsetopt correct_all
alias cs="sshpass -f ~/.clearance ssh mwolff@$CS_SERVER"
alias cssftp="sshpass -f ~/.clearance sftp mwolff@$CS_SERVER"
alias ls='ls -G '
alias grep='grep --color=auto'
alias spotify='if ! pgrep -x "Spotify" > /dev/null; then open /Applications/Spotify.app/ --background; sleep 3; fi; spotify'
alias song='spotify status'
alias play='spotify play'
alias shuf='spotify toggle shuffle'
alias s='shuf'
alias skip='spotify next'
alias next='spotify next'
alias n='next'
alias p='spotify prev'
alias c='spotify status; spotify share | head -n 2'
alias moderat='play artist moderat'
alias m='moderat'
alias eden='play artist eden'
alias e='eden'
alias push='git push -u origin master'
alias pull='git pull'
alias rmasl='setopt +o nomatch;
	     sudo rm /private/var/log/asl/*.asl 2> /dev/null;
	     sudo rm /private/var/log/asl/Logs/* 2> /dev/null;
	     sudo rm /Users/matthew/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*.txt 2> /dev/null;
             sudo rm -rf /Users/matthew/Library/Caches/com.spotify.client/Data/* 2> /dev/null'
alias asl='open /private/var/log/asl/Logs/'
alias mem='sudo echo -n "";TMP=$(memory); rmasl > /dev/null 2> /dev/null; echo $TMP " ->" $(memory)'
alias memory='free=$(df -h | grep "/dev/disk1" | grep -oEe "[1-9]{1,2}\.[0-9]Gi|[^0-9][0-9]{2}Gi" | tr "Gi" " " | head -n1);  echo $(printf "%.3g" $(($free + 0.7))) GB'
alias csfol='cd ~/Desktop/College/Junior/CS/'
alias reset_cal='pkill -9 "Calendar";pkill -9 "CalendarAgent"; rm /Users/matthew/Library/Calendars/Calendar\ Cache*; open /Applications/Calendar.app'
alias search='grep -rwn * -e '
alias files='diff -rq ~/downloads/diffOG/ ~/downloads/diffFresh/'
alias tweet='python ~/github/theDNABot/tweet.py'
alias shrink='export PS1="\u > "' # temporarily shrinks the prompt so that it doesn't show the working directory
alias mcfol='cd /Volumes/mcmahonlab/lakes_data/Metagenomes/Mendota/MergedReads-Mendota/fasta'
alias mcmahon='open "smb://mwolff3:$(cat ~/.clearance)@bact-mcmahonlab.drive.wisc.edu/"'
alias mc='cd ~/desktop/college/research/mcmahon/'
alias src='source ~/.bashrc; source ~/.zshrc'
alias theme='source ~/.zshrc' # picks a random theme
alias chtc='ssh mwolff3@submit-3.chtc.wisc.edu'
alias daddy='sudo'
alias src='source ~/.zshrc'
alias glist='git diff --cached'
alias vol='cd /Volumes/mcmahonlab/lakes_data/Metagenomes/Mendota/MergedReads-Mendota/fasta/lenfiltered150/'
alias volhome='cd /Volumes/mcmahonlab/home/mwolff3/'
alias calc='~/.calc/./prog'
alias self='ssh `networksetup -getcomputername`.local'
alias rc='vim ~/.zshrc'
alias force='git push -u -f origin master'
alias 'oops!'='gaa && gcn! && force'  # correct a fuck up w/o new commit
alias gits='git status'
alias l='ls -lAh'
alias root='su -'
alias bfg='java -jar ~/Dev/bfg-1.13.0.jar'
alias db='autotunnel databases'
alias glust='ssh mwolff3@transfer.chtc.wisc.edu'
alias college='cd ~/Desktop/College/Senior/Fall'
alias dl='cd ~/Downloads'
alias 301='cd ~/Desktop/CS301/'
alias res='mc'
alias research='res'
alias die='cs -t bash -ci die'
alias grad='cd ~/Desktop/grad_school/'
alias g='Rscript /Users/matthew/Desktop/grad_school/grad_school.r'

alias check='moss -l cc -b ~/Downloads/DBP2/buffer_base.cpp ~/Downloads/DBP2/adi.cpp ~/Downloads/databases/BufMgr/src/buffer.cpp'
alias diff1='diff -wy ~/Downloads/DBP2/buffer1.cpp ~/Downloads/databases/BufMgr/src/buffer.cpp'
alias diff2='diff -wy ~/Downloads/DBP2/buffer2.cpp ~/Downloads/databases/BufMgr/src/buffer.cpp'

alias docker_stop='docker rm $(docker ps -a -q)'
alias dls='docker images'
alias drun='docker run -i -t'
alias drm='docker rmi'

alias matthew='ssh 192.168.0.186'
alias trans="Rscript -e 'suppressMessages(library(tidyverse)); read_csv(\"~/.scripts/sex.csv\", col_types=cols())'"
alias DNA='dna'
alias msg='message'
alias me='message me'
