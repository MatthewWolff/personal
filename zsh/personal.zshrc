export ZSH=/Users/matthew/.oh-my-zsh # ZSH installation path

ZSH_THEME="wolffy" # can set to random too, optionally constrainign the theme pool below
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "clean" "wolffy")

# disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# enable command auto-correction.
ENABLE_CORRECTION="true"

# display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git battery
)

##################################################################################################
## USER CONFIGURATION
source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # valid command highlighter
export SAVEHIST=1000000

# .VIMRC
if ! grep -q wolffy ~/.vimrc; then
cat << EOF >> ~/.vimrc 
"""wolffy .vimrc begin"""
syntax on
set title                       " sets title of window
set formatoptions=croq          " (fo) influences how vim automatically formats text
set showmatch                   " (sm) briefly jump to matching bracket when inserting one
set autoindent                  " (ai)
set smartindent                 " (si) used in conjunction with autoindent
set ruler                       " (ru) show the cursor position at all times
set backspace=indent,eol,start  " (bs) allow backspacing on indents and line breaks
set linebreak                   " (lbr) wrap long lines at a space instead of in the middle of a word
set incsearch                   " (is) highlights what you are searching for as you type
set hlsearch                    " (hls) highlights all instances of the last searched string
set ignorecase                  " (ic) ignores case in search patterns
set smartcase                   " (scs) don't ignore case when the search pattern has uppercase
set shiftwidth=4                " (sw) spaces used in each step of autoindent (as well as << and >>)
set textwidth=80                " (tw) number of columns before an automatic line break
function! Strip()               " strip whitespace from end of lines ( call Strip() )
  :%s/\s*$//g
  :'^
endfunction
"""wolffy .vimrc end"""
EOF
fi

##################################################################################################
## FUNCTIONS
trash() { mv $* ~/.Trash;}
addalias()
{
  new_alias="alias $(sed -e "s/=/='/" -e "s/$/'/" <<< $1)"
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
sublime() {  open $@ -a "/Applications/Sublime Text.app/"; }
pycharm() {  open $@ -a "/Applications/PyCharm.app"; }
chrome()  {  open $@ -a "/Applications/Google Chrome.app/"; }
clion()   {  open $@ -a "/Applications/Clion.app"; }
settheme() { sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc && source ~/.zshrc; }
send_glust() { scp $* mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3; }
get_glust() { scp mwolff3@transfer.chtc.wisc.edu:/mnt/gluster/mwolff3/$1 .; }
cd() { builtin cd $@ && ls; }
clean_grad()
{
  mv ~/Downloads/GradSchool* ~/Desktop/grad_school/latex_essays/ &>/dev/null
  builtin cd $_
  for f in GradSchool_*; do mv $f ${f#GradSchool_}; done
  builtin cd $OLDPWD
}
set_git_time() { 
    if [[ -z $1 ]]; then 
      echo "format: \"Sat Jan 12 19:01 2019 -0600\""
    else
      GIT_COMMITTER_DATE="$1"
      git commit --amend --no-edit --date "$1" 
      git push -f origin master
    fi
}
colors() {
echo '
  _RED = "\033[31m"
  _RESET = "\033[0m"
  _BOLDWHITE = "\033[1m\033[37m"
  _YELLOW = "\033[33m"
  _CYAN = "\033[36m"
  _PURPLE = "\033[35m"
  _CLEAR = "\033[2J"  # clears the terminal screen'
}

##################################################################################################
## VARIABLES
theme=$RANDOM_THEME # only valid if using random theme
export CS_SERVER=rockhopper-08.cs.wisc.edu

##################################################################################################
## PATH STUFF
export PATH=$HOME/.scripts:$PATH
export PATH=$HOME/anaconda3/bin:$PATH
export PATH=$HOME/Desktop/College/research/DESMAN/bin:$HOME/Desktop/College/research/DESMAN/scripts:$PATH
export PATH=$HOME/GitHub/twitter:$PATH
export DESMANHOME=/Users/matthew/Desktop/College/research/DESMAN

##################################################################################################
## ALIASES
# UTILITY
alias daddy='sudo'
alias ls='ls -G '
alias l='ls -lAh'
alias grep='grep --color=auto'
alias src='source ~/.zshrc'
alias root='su -'
alias shrink='export PS1="$USER > "' # shrinks the prompt so that it doesn't show the working directory
alias search='grep -rwn * -e '
alias rc='vim ~/.zshrc'
alias bfg='java -jar ~/Dev/bfg-1.13.0.jar' # for cleaning up git repos (efficiently)
alias msg='message'
alias me='message me'
alias g='Rscript /Users/matthew/Desktop/grad_school/applications/grad_school.r' # display grad summary
alias find_large='du -sh * 2>/dev/null | grep -E "[0-9]+(\.[0-9])?G.*"'
alias jn='jupyter notebook'

# GIT
alias glist='git diff --cached'
alias push='git push -u origin master'
alias pull='git pull origin master'
alias force='git push -uf origin master'
alias 'oops!'='gaa && gcn! && force'  # correct a fuck up w/o new commit
alias gits='git status'

# SPOTIFY
alias spotify='if ! pgrep -x "Spotify" > /dev/null; then open /Applications/Spotify.app/ --background; sleep 3; fi; spotify'
alias song='spotify status'
alias play='spotify play'
alias shuf='spotify toggle shuffle'
alias skip='spotify next'
alias next='spotify next'
alias n='next'
alias p='spotify prev'
alias c='spotify status; spotify share | head -n 2'
alias moderat='play artist moderat'
alias eden='play artist eden'
alias m='moderat'
alias e='eden'
alias s='play artist shiloh'
alias i='play album interstellar'
alias x='play artist xxxTentacion'

# SSH
alias cs="sshpass -f ~/.clearance ssh mwolff@$CS_SERVER -t zsh"
alias cssftp="sshpass -f ~/.clearance sftp mwolff@$CS_SERVER"
alias chtc='ssh mwolff3@submit-3.chtc.wisc.edu -t bash'
alias self='ssh `networksetup -getcomputername`.local'
alias db='autotunnel datasci'
alias glust='ssh mwolff3@transfer.chtc.wisc.edu'
alias die="sshpass -f ~/.clearance ssh mwolff@$CS_SERVER -t bash -ci die"
alias matthew='ssh 192.168.0.186'
alias liz='ssh mwolff@10.128.254.21 -t zsh'

# DOCKER
alias docker_stop='docker rm $(docker ps -a -q)'
alias dls='docker images'
alias drun='docker run -i -t'
alias drm='docker rmi'
alias ds='docker run -i -t mwolff3/cs639'

# NAVIGATION
alias dl='cd ~/Downloads'
alias 301='cd ~/Desktop/College/Senior/Spring/cs301/'
alias mc='cd ~/desktop/college/research/mcmahon/'
alias res='mc'
alias research='res'
alias grad='cd ~/Desktop/grad_school/'
alias csfol='cd ~/Desktop/College/Junior/CS/'
alias mcmahon='open "smb://mwolff3:$(cat ~/.clearance)@bact-mcmahonlab.drive.wisc.edu/"'
alias college='cd /Users/matthew/Desktop/College/Senior/spring'
alias dsa='cd /Users/matthew/Desktop/College/Senior/spring/DataScience/github/assignments'
alias github='cd ~/github'

# MEMORY MANAGEMENT
alias rmasl='setopt +o nomatch;
	     sudo rm /private/var/log/asl/*.asl 2> /dev/null;
	     sudo rm /private/var/log/asl/Logs/* 2> /dev/null;
	     sudo rm ~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*.txt 2> /dev/null;
             sudo rm -rf ~/Library/Caches/com.spotify.client/Data/* 2> /dev/null'
alias asl='open /private/var/log/asl/Logs/'
alias mem='sudo echo -n "";TMP=$(memory); rmasl > /dev/null 2> /dev/null; echo $TMP " ->" $(memory)'
alias memory='free=$(df -h | grep "/dev/disk1" | grep -oEe "[1-9]{1,2}\.[0-9]Gi|[^0-9][0-9]{2}Gi" | tr "Gi" " " | head -n1);  echo $(printf "%.3g" $(($free + 0.7))) GB'

# OTHER
alias tweet='python ~/github/theDNABot/tweet.py'
alias calc='~/.calc/./prog'
alias trans="Rscript -e 'suppressMessages(library(tidyverse)); read_csv(\"~/.scripts/sex.csv\", col_types=cols())'"
alias DNA='dna'
alias tweetas='tweet_as'
