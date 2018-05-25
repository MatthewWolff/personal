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
PROMPT_COMMAND=parse_git_branch
PS_GIT="$YELLOW\$PS_BRANCH"
PS_TIME="\[\033[\$((COLUMNS-10))G\] $OB\t$CB"
HIST_NO="$OB\!$CB"
EXIT_CODE="$OB$ERR$CB"
PS_INFO="$UP_PIPE$OB$BLUE\w$CB$HPIPE$OB$WHITE\u@\h$CB$HPIPE${HIST_NO} $(ssh_connection)"
export PS1="${PS_INFO} ${PS_GIT}${PS_TIME}\n${RESET}$DOWN_PIPE${EXIT_CODE} > "

### PACKAGES
# added by Anaconda3 installer
export PATH="/home/$USER/anaconda3/bin:$PATH"

### FUNCTIONS
addalias()
{
        new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
        echo $new_alias >> ~/.bashrc
        source ~/.bashrc # order matters
}

### ALIASES
alias l='ls -lah'
alias shrink='export PS1="\u > "' # temporarily shrinks the prompt so that it doesn't show the working directory
alias search='grep -rwn * -e '
alias push='git push -u origin master'
alias pull='git pull'
alias ls='ls --color'
alias daddy='sudo'
alias grep='grep --color=auto'
alias colors='/home/$USER/.colors.sh'
