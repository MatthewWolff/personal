export ZSH=/Users/matthew/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="wolffy"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "clean" "wolffy")

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

##################################################################################################
## FUNCTIONS
mossy()
{
  ./moss -l c -b diffFresh/"$1"  diffRevamp/"$1" diffOG/"$1"  diffOG2/"$1"
}
comp()
{
  diff -wy ~/downloads/diffOG/"$1" ~/downloads/diffFresh/"$1"
}
addalias()
{
  new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
  echo $new_alias >> ~/.bashrc
  echo $new_alias >> ~/.zshrc
  source ~/.bashrc;source ~/.zshrc
}
sublime() 
{ 
  open "$@" -a "/Applications/Sublime Text.app/" 
}
pycharm()
{
  open "$@" -a "/Applications/PyCharm.app"
}
settheme()
{
  sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc
  source ~/.zshrc
}
send_glust()
{
  sshpass -f ~/.clearance scp $* mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3
}
get_glust()
{
  sshpass -f ~/.clearance scp mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3/$1 .
}
length()
{
  stat $@ | cut -d' ' -f8
}
cd()
{
  builtin cd $@ && ls;
}

##################################################################################################
## VARIABLES
theme=$RANDOM_THEME # only valid if using random theme

##################################################################################################
## PATH STUFF
export PATH=$HOME/.scripts:$PATH
export SAVEHIST=1000000
export PATH=$HOME/anaconda2/bin:$PATH

##################################################################################################
## ALIASES
alias cs='sshpass -f ~/.clearance ssh mwolff@royal-08.cs.wisc.edu'
alias cssftp='sshpass -f ~/.clearance sftp mwolff@royal-08.cs.wisc.edu'
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
alias ci='spotify info'
alias i='spotify info'
alias moderat='play artist moderat'
alias m='moderat'
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
alias mc='cd ~/desktop/college/research/mcmahon/mapMetasVsRefs'
alias src='source ~/.bashrc; source ~/.zshrc'
alias theme='source ~/.zshrc' # picks a random theme
alias chtc='ssh mwolff3@submit-3.chtc.wisc.edu'
alias daddy='sudo'
alias src='source ~/.bashrc; source ~/.zshrc'
alias gitforce='git push origin master --force'
alias glist='git diff --cached'
alias vol='cd /Volumes/mcmahonlab/lakes_data/Metagenomes/Mendota/MergedReads-Mendota/fasta/lenfiltered150/'
alias volhome='cd /Volumes/mcmahonlab/home/mwolff3/'
alias calc='~/.calc/./prog'
alias self='ssh `networksetup -getcomputername`.local'
alias DNA='Rscript ~/.scripts/sequence.r'
alias eden='play artist eden && sleep 0.3 && ci'
alias rc='vim ~/.zshrc'
alias matthew='ssh 192.168.168.50'
alias matthew='ssh 192.168.11.2'
alias force='git push -u -f origin master'
alias 'oops!'='gaa && gcn! && force'  # correct a fuck up w/o new commit
alias gits='git status'
alias l='ls -lAh'
alias root='su -'
alias bfg='java -jar ~/Dev/bfg-1.13.0.jar'
alias db='cd ~/Desktop/College/Senior/Fall/Databases && jupyter-notebook'