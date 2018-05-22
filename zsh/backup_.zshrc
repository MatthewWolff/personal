# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/matthew/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="funky" #"robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME is random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array has no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "clean")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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
comp_check()
{
  diff -wy ~/downloads/diffOG/"$1" ~/downloads/diffRevamp/"$1"
}
compk()
{
  diff -wy ~/downloads/diffOG/kernel/"$1" ~/downloads/diffFresh/kernel/"$1"
}
compu()
{
  diff -wy ~/downloads/diffOG/user/"$1" ~/downloads/diffFresh/user/"$1"
}
compi()
{
  diff -wy ~/downloads/diffOG/include/"$1" ~/downloads/diffFresh/include/"$1"
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
settheme()
{
  # linenum=$(grep -n "^ZSH_THEME=" ~/.zshrc | cut -f1 -d:)
  sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc
  source ~/.zshrc
}
glust()
{
  sshpass -f ~/clearance scp $* mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3
}
get_glust()
{
  sshpass -f ~/clearance scp mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3/$1 .
}
length()
{
  stat $@ | cut -d' ' -f8
}

##################################################################################################
## VARIABLES
theme=$RANDOM_THEME # only valid if using random theme


##################################################################################################
## ALIASES
alias cs='sshpass -f ~/clearance ssh mwolff@royal-08.cs.wisc.edu'
alias cssftp='sshpass -f ~/clearance sftp mwolff@royal-08.cs.wisc.edu'
alias ls='ls -G '
alias grep='grep --color=auto'
alias spot='open /Applications/Spotify.app/ --background; sleep 3;'
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
alias moderat='if ! pgrep -x "Spotify" > /dev/null; then spot; fi; play artist moderat'
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
alias memory='free=$(df -h | grep "/dev/disk1" | grep -oEe "[1-9]{1,2}\.[0-9]Gi|[^0-9][0-9]{2}Gi" | tr "Gi" " ");  echo $(printf "%.3g" $(($free + 0.7))) GB' 
alias csfol='cd ~/Desktop/College/Junior/CS/'
alias hadoop='sshpass -f ~/clearance2 ssh mwolff3@systemt.datascientistworkbench.com'
alias s2='sshpass -f ~/clearance rsync -aP -v ~/desktop/p2b/xv6/* mwolff@royal-08.cs.wisc.edu:xv6/'
alias hadoopsftp='sshpass -f ~/clearance2 sftp mwolff3@systemt.datascientistworkbench.com'
alias reset_cal='pkill -9 "Calendar";pkill -9 "CalendarAgent"; rm /Users/matthew/Library/Calendars/Calendar\ Cache*; open /Applications/Calendar.app'
alias matthew='sshpass -f ~/clearance ssh matthew@192.168.11.2'
alias search='grep -rwn * -e '
alias files='diff -rq ~/downloads/diffOG/ ~/downloads/diffFresh/'
alias tweet='python ~/github/theDNABot/tweet.py'
alias shrink='export PS1="\u > "' # temporarily shrinks the prompt so that it doesn't show the working directory
alias mcfol='cd /Volumes/mcmahonlab/lakes_data/Metagenomes/Mendota/MergedReads-Mendota/fasta'
alias mcmahon='open "smb://mwolff3:$(cat ~/clearance)@bact-mcmahonlab.drive.wisc.edu/"'
alias mc='cd ~/desktop/college/research/mcmahon/mapMetasVsRefs'
alias src='source ~/.bashrc; source ~/.zshrc'
alias theme='source ~/.zshrc' # picks a random theme
alias chtc='sshpass -f ~/clearance ssh mwolff3@submit-3.chtc.wisc.edu'
alias daddy='sudo'
alias src='source ~/.bashrc; source ~/.zshrc'
alias gitforce='git push origin master --force'
alias glist='git diff --cached'
alias vol='cd /Volumes/mcmahonlab/lakes_data/Metagenomes/Mendota/MergedReads-Mendota/fasta/lenfiltered150/'
alias volhome='cd /Volumes/mcmahonlab/home/mwolff3/'
alias calc='~/.calc/./prog'
