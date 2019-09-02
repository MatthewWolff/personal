# ZSH RC
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
export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=$HOME/.scripts:$PATH
export PATH=$HOME/GitHub/twitter:$PATH

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
cd() { builtin cd $@ && ls; }
rmalias() {  perl -pi -e "s/^alias $@/# $&/" ~/.zshrc; }
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
pycharm() {  open $@ -a "/Applications/PyCharm.app"; }
chrome()  {  open $@ -a "/Applications/Google Chrome.app"; }
clion()   {  open $@ -a "/Applications/Clion.app"; }
gimp()    {  open $@ -a "/Applications/GIMP-2.10.app"; }
vscode()  {  open $@ -a "/Applications/Visual Studio Code.app"; }
rstudio() {  open $@ -a "/Applications/Rstudio.app"; }
settheme() { sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc && source ~/.zshrc; }
set_git_time() {
    if [[ -z $1 ]]; then
      echo "format: \"Sat Jan 12 19:01 2019 -0600\""
    else
      GIT_COMMITTER_DATE="$1"
      git commit --amend --no-edit --date "$1"
      git push -f origin master
    fi
}
color() {
  cat <<"END"
_RED = \033[31m
_RESET = \033[0m
_BOLDWHITE = \033[1m\033[37m
_YELLOW = \033[33m
_CYAN = \033[36m
_PURPLE = \033[35m
_CLEAR = \033[2J  # clears the terminal screen
END
}
memory() {
	free=$(df -h | grep "/dev/disk1" | grep -oEe "[1-9]{1,2}\.[0-9]Gi|[^0-9][0-9]{2}Gi" | tr "Gi" " " | head -n1)
	echo "$(printf "%.3g" $(($free + 0.7))) GB"
}
mem() {
	TMP=$(memory)
	setopt +o nomatch
	sudo rm -rf /private/var/log/asl/*.asl /private/var/log/asl/Logs/* \
				~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail/*.txt \
				~/Library/Caches/com.spotify.client/Data/* \
				&>/dev/null
	echo "$TMP -> $(memory)"
}

##################################################################################################
## VARIABLES
theme=$RANDOM_THEME # only valid if using random theme
export CS_SERVER=rockhopper-08.cs.wisc.edu

##################################################################################################
## ALIASES
# UTILITY
alias daddy='sudo'
alias please='sudo'
alias ls='ls -G '
alias l='ls -lAh'
alias grep='grep --color=auto'
alias src='source ~/.zshrc'
alias root='su -'
alias shrink="export PS1=\"$USER > \"" # shrinks the prompt so that it doesnt show the working directory
alias search='grep -rwn * -e '
alias rc='vim ~/.zshrc'
alias msg='message'
alias me='message me'
alias g='Rscript /Users/matthew/Desktop/grad_school/applications/grad_school.r' # display grad summary
alias find_large='du -sh * 2>/dev/null | grep -E "[0-9]+(\.[0-9])?G.*"'
alias jn='jupyter notebook'
alias sublime=subl

# GIT
alias glist='git diff --cached'
alias push='git push -u origin $(git_current_branch)'
alias pull='git pull origin $(git_current_branch)'
alias force='git push -uf origin $(git_current_branch)'
alias 'oops!'='gaa && gcn! && force'  # correct a fuck up w/o new commit
alias gits='git status'

# SPOTIFY
alias spotify='if ! pgrep -x "Spotify" > /dev/null; then open /Applications/Spotify.app/ --background; sleep 3; fi; spotify'
alias song='spotify status'
alias play='spotify play'
alias shuf='spotify toggle shuffle'
alias next='spotify next'
alias prev='spotift prev'
alias skip=next
alias n=next
alias p=prev
alias c='spotify status; spotify share | head -n 2'
alias disc='spotify play uri spotify:playlist:37i9dQZEVXcHX1sGVICYXF >/dev/null && echo playing discovery playlist...'
alias interstellar='spotify play uri spotify:album:3N8fGhRcHWqyy0SfWa92H0 >/dev/null && echo playing interstellar soundtrack...'
alias moderat='spotify play uri spotify:artist:2exkZbmNqMKnT8LRWuxWgy >/dev/null && echo playing moderat...'
alias shiloh='spotify play uri spotify:artist:1wxPItEzr7U7rGSMPqZ25r >/dev/null && echo playing shiloh dynasty...'
alias eden='spotify play uri spotify:artist:1t20wYnTiAT0Bs7H1hv9Wt >/dev/null && echo playing eden...'
alias xxx='spotify play uri spotify:artist:15UsOTVnJzReFVN1VCnxy4 >/dev/null && echo playing xxxTentacion...'
alias i=interstellar
alias m=moderat
alias s=shiloh
alias e=eden
alias x=xxx  # xxxTentacion
alias vu='spotify vol up'
alias vd='spotify vol down'

# SSH
alias cs="sshpass -f ~/.clearance ssh mwolff@$CS_SERVER -t zsh"
alias cssftp="sshpass -f ~/.clearance sftp mwolff@$CS_SERVER"
alias self='ssh $(networksetup -getcomputername).local'
alias db='autotunnel datasci'
alias die="sshpass -f ~/.clearance ssh mwolff@$CS_SERVER -t bash -ci die"
alias matthew='ssh 192.168.0.186'

# DOCKER
alias docker_stop='docker rm $(docker ps -a -q)'
alias dls='docker images'
alias drun='docker run -i -t'
alias drm='docker rmi'
alias ds='docker run -i -t mwolff3/cs639'

# NAVIGATION
alias dl='cd ~/Downloads'
alias 301='cd ~/Desktop/College/4Senior/Spring/cs301/'
alias mc='cd ~/desktop/college/research/mcmahon/'
alias research='res'
alias grad='cd ~/Desktop/grad_school/'
alias college='cd ~/Desktop/College/4Senior/spring'
alias dsa='cd ~/Desktop/College/4Senior/spring/DataScience/assignments'
alias github='cd ~/github'
alias movies='open ~/Library/MATLAB/CS\ 368/'
alias cmu='cd /Users/matthew/Desktop/grad_school/cmu'

# OTHER
alias tweet='python ~/github/theDNABot/tweet.py'
alias calc='~/.calc/./prog'
alias trans="Rscript -e 'suppressMessages(library(tidyverse)); read_csv(\"~/.scripts/sex.csv\", col_types=cols())'"
alias DNA='dna'
alias tweetas='tweet_as'
alias obfuscate='bash-obfuscate'
