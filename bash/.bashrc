# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# CUSTOM PROMPT
ERR="\$(if [ \$? == 0 ]; then echo '>:)'; else echo '\[\033[0;31m\]>:(\[\033[0m\]'; fi)"
RESET="\[\033[0m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\033[0;33m\]"
WHITE="\[\033[1;37m\]"
GRAY="\[\033[0;37m\]"
HPIPE="\[\e(0\]q\[\e(B\]"
UP_PIPE="\[\e(0\]lq\[\e(B\]"  # l for the initial up, then q as connect
DOWN_PIPE="\[\e(0\]mq\[\e(B\]"  # see above. m=down
OB='\[\033[0;37m\][\[\033[0m\]' # open bracket
CB='\[\033[0;37m\]]\[\033[0m\]' # close bracket

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "$RED(ssh)$RESET "
  fi
}

PS_LINE=`printf -- '- %.0s' {1..200}`
function parse_git_branch {
  PS_BRANCH=''
  PS_FILL=${PS_LINE:0:$COLUMNS}
  if [ -d .svn ]; then
    PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
    return
  elif [ -f _FOSSIL_ -o -f .fslckout ]; then
    PS_BRANCH="(fossil $(fossil status|awk '/tags/{print $2}')) "
    return
  fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  PS_BRANCH="(git ${ref#refs/heads/}) "
}
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}
PROMPT_COMMAND=parse_git_branch
PS_GIT="$YELLOW\$PS_BRANCH"
PS_TIME="\[\033[\$((COLUMNS-10))G\] $OB\T$CB"
HIST_NO="$OB\!$CB"
EXIT_CODE="$OB$ERR$CB"

PS_INFO="$UP_PIPE$OB$BLUE\w$CB$HPIPE$OB$WHITE\u$YELLOW@$WHITE$(box_name)$CB$HPIPE${HIST_NO} $(ssh_connection)"
export PS1="${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}$DOWN_PIPE${EXIT_CODE} > "

### ETERNAL BASH HISTORY
# ---------------------
# https://stackoverflow.com/a/19533853/
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

### PACKAGES
export PATH=$HOME/scripts:$PATH

### FUNCTIONS
trash() { mv $* ~/.Trash;}
addalias()
{
  new_alias="alias $(sed -e "s/=/='/" -e "s/$/'/" <<< $1)"
  if grep -q $new_alias ~/.bashrc; then
    if grep -q "^$new_alias" ~/.bashrc; then echo "alias already present"; exit 1
    elif grep -q "# $new_alias" ~/.bashrc; then perl -pi -e"s/# (?=$new_alias)//" ~/.bashrc
    else echo "it's in there somewhere but undefined?"; exit 1; fi
    source ~/.bashrc
  else
    echo $new_alias >> ~/.bashrc
    source ~/.bashrc
  fi
}
rmalias() {  perl -pi -e "s/^alias $@/# $&/" ~/.bashrc; }
cd() { builtin cd $* && ls -G;}

### .VIMRC
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

### ALIASES
# UTILITY
alias daddy='sudo'
alias please='sudo'
alias ls='ls -G'
alias l='ls -lAh'
alias grep='grep --color=auto'
alias src='source ~/.bashrc'
alias root='su -'
alias shrink="export PS1=\"$USER > \"" # shrinks the prompt so that it doesn't show the working directory
alias search='grep -rn * -e '
alias rc='vim ~/.bashrc'
alias find_large='du -sh * 2>/dev/null | grep -E "[0-9]+(\.[0-9])?G.*"'
alias jn='jupyter notebook'

# GIT
alias glist='git diff --cached'
alias push='git push -u origin $(git_current_branch)'
alias pull='git pull origin $(git_current_branch)'
alias force='git push -uf origin $(git_current_branch)'
alias 'oops!'='gaa && gcn! && force'  # correct a fuck up w/o new commit
alias gits='git status'

# SSH
alias self='ssh `networksetup -getcomputername`.local' # mac only?

# DOCKER
alias docker_stop='docker rm $(docker ps -a -q)'
alias dls='docker images'
alias drun='docker run -i -t'
alias drm='docker rmi'

# NAVIGATION
alias github='cd ~/github'

# OTHER
alias colors='bash ~/.colors.sh'
