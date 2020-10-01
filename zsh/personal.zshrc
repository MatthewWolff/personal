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
export SAVEHIST=999999999
export HISTSIZE=$SAVEHIST
export HISTFILE=~/.zsh_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=$HOME/.scripts:$PATH
export PATH=$HOME/GitHub/twitter:$PATH
export PATH=$HOME/.nimble/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export GRB_LICENSE_FILE=/Users/matthew/Dev/Licenses/gurobi.lic
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home
export GOPATH=$HOME/dev/go
export PATH=$PATH:$(go env GOPATH)/bin

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

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

##################################################################################################
## FUNCTIONS
trash() { mv $* ~/.Trash;}
cd() { builtin cd $@ && ls; }
src() { source ~/.zshrc; }
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
chrome()  {  open $@ -a "/Applications/Google Chrome.app"; }
clion()   {  open $@ -a "/Applications/Clion.app"; }
gimp()    {  open $@ -a "/Applications/GIMP-2.10.app"; }
vscode()  {  open $@ -a "/Applications/Visual Studio Code.app"; }
rstudio() {  open $@ -a "/Applications/Rstudio.app"; }
pycharm() {  open $@ -a "/Applications/Pycharm.app"; }
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
git_rewrite() {
  if [[ -z $1 ]]; then
    echo "please supply the email to replace as an argument"
  else
    git filter-branch --env-filter '
		WRONG_EMAIL='"$1"'
		NEW_NAME="Matthew Wolff"
		NEW_EMAIL="mm.wolff@chi-squared.org"

		if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
		then
		    export GIT_COMMITTER_NAME="$NEW_NAME"
		    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
		fi
		if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
		then
		    export GIT_AUTHOR_NAME="$NEW_NAME"
		    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
		fi
		' --tag-name-filter cat -- --branches --tags
	echo "now push!"
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

swap() {
	mv "$1" "$1.swp"
	mv "$2" "$1"
	mv "$1.swp" "$2"
	echo "swapped $1 and $2"
}
search_messages() {
  regex="$@"
  database="$HOME/library/messages/chat.db"
  use_extension=".load /usr/lib/sqlite3/pcre.so"
  query="SELECT text FROM message WHERE text REGEXP '$regex'"
  sqlite3 "$database" -cmd "$use_extension" "$query"
}
notes() {
  document=/Users/matthew/Desktop/grad_school/ms/first_year/schwartz/notes.md
  if [[ -z $1 ]]; then
    cat $document
  else
    echo "* $* || $(date)" >> $document
  fi
}
use_credentials() {
  [[ -z $1 ]] && echo 'usage: use_credentials [credential file.csv]' && return 1
  [[ ! -f $1 ]] && echo 'invalid file provided' && return 1 
  file=$1
  data=$(cat $file | tail -n1 | sed -E $'s/,/\t/g')
  export AWS_ACCESS_KEY_ID=$(awk '{ print $2 }' <<< $data)
  export AWS_SECRET_ACCESS_KEY=$(awk '{ print $3}' <<< $data)
}
use_credentials ~/Downloads/CloudComputingCredentials.csv
connect() {
  [[ -z $1 ]] && echo 'usage: connect [ip]' && return 1 
  ssh -i ~/.ssh/cloud_compute_aws.pem clouduser@$1
}
connect_jupyter() {
  [[ -z $1 ]] && echo 'usage: connect [ip] [port=8888]' && return 1
  [[ -z $2 ]] && PORT=8888 || PORT=$2
  ssh -i ~/.ssh/cloud_compute_aws.pem -L ${PORT}:localhost:${PORT} clouduser@$1
}
grab() {
  [[ ! $# = 3 ]] && echo 'usage: grab [ec2 ip address] [project number] [remote_folder]' && return 1
  ip=$1; project_num=$2; remote_folder=$3
  mkdir -p /cloud_computing/p${project_num}/remote
  rsync -Pav -e "ssh -i ~/.ssh/cloud_compute_aws.pem" clouduser@${ip}:${remote_folder}/ /cloud_computing/p${project_num}/remote/
}
upcloud() {
  [[ ! $# = 3 ]] && echo 'usage: upcloud [ec2 ip address] [project number] [remote_folder]' && return 1
  ip=$1; project_num=$2; remote_folder=$3
  rsync -Pav -e "ssh -i ~/.ssh/cloud_compute_aws.pem" /cloud_computing/p${project_num}/remote/ clouduser@${ip}:${remote_folder}/
}
use_venv() {
  if [[ -n $1 ]]; then  # assume we're not already in the venv
    venv_path=$1    
    [[ ! -f $venv_path/bin/activate ]] && echo "venv $venv_path does not exist" >&2 && return 1
    source $venv_path/bin/activate
  fi
  venv_name=$(perl -nle 'print $& if m{^\(.*?\)}' <<< "$PROMPT")
  raw_prompt=$(perl -p -e 's/^\(.*?\) //' <<< "$PROMPT")
  PROMPT=$(perl -p -e "s/ > / ${fg_bold[white]}${venv_name}${reset_color}$&/" <<< "$raw_prompt")
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
alias root='su -'
alias shrink="export RPROMPT=; export PS1=\"$USER > \"" # shrinks the prompt so that it doesnt show the working directory
alias search='grep -rn * -e '
alias rc='vim ~/.zshrc'
alias msg='message'
alias me='message me'
alias g='Rscript /Users/matthew/Desktop/grad_school/initial_apps/grad_school.r' # display grad summary
alias find_large='du -sh * .* 2>/dev/null | grep -E "[0-9]+(\.[0-9])?G.*"'
alias jn='jupyter notebook'
alias sublime=subl
alias matlab='/Applications/MATLAB.app/bin/matlab'
alias checkstyle='java -jar /cloud_computing/checkstyle.jar -c /cloudcomputing_course_checkstyle.xml .'
alias az='az account show | grep -oE "mwolff.+com"; az'
alias apps='/Users/matthew/Desktop/grad_school/phd_apps/apps.r'
alias tf='terraform'

# GIT
alias glist='git diff --cached'
alias push='git push -u origin $(git_current_branch)'
alias pull='git pull origin $(git_current_branch)'
alias force='git push -uf origin $(git_current_branch)'
alias 'oops!'='gaa && gcn! && force'  # correct a fuck up w/o new commit
alias gits='git status'
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"

# SPOTIFY
alias spotify='if ! pgrep -x "Spotify" > /dev/null; then open /Applications/Spotify.app/ --background; sleep 3; fi; spotify'
alias song='spotify status'
alias play='spotify play'
alias shuf='spotify toggle shuffle'
alias next='spotify next'
alias prev='spotify prev'
alias skip=next
alias n=next
alias p=prev
alias c='spotify status; spotify share | head -n 2'
alias disc='spotify play uri spotify:playlist:37i9dQZEVXcHX1sGVICYXF >/dev/null && echo playing discovery playlist...'
alias werk='spotify play uri spotify:playlist:0c4qVPXwIarAIOIPsgI0Gp >/dev/null && echo playing werk playlist...'
alias interstellar='spotify play uri spotify:album:3N8fGhRcHWqyy0SfWa92H0 >/dev/null && echo playing interstellar soundtrack...'
alias moderat='spotify play uri spotify:artist:2exkZbmNqMKnT8LRWuxWgy >/dev/null && echo playing moderat...'
alias shiloh='spotify play uri spotify:playlist:7qd17uUKPGKXXDzSLMu9dJ >/dev/null && echo playing shiloh dynasty...'
alias eden='spotify play uri spotify:artist:1t20wYnTiAT0Bs7H1hv9Wt >/dev/null && echo playing eden...'
alias xxx='spotify play uri spotify:artist:15UsOTVnJzReFVN1VCnxy4 >/dev/null && echo playing xxxTentacion...'
alias i=interstellar
alias m=moderat
alias s=shiloh
alias e=eden
alias x=xxx  # xxxTentacion
alias vu='spotify vol $(( $(spotify vol | perl -nle "print $& if m{[0-9]{1,2}(?=\.)}") + 11 ))'
alias vd='spotify vol $(( $(spotify vol | perl -nle "print $& if m{[0-9]{1,2}(?=\.)}") - 9 ))'

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
alias drun='docker run -it --rm'
alias drm='docker rmi'
alias dps='docker ps'

# NAVIGATION
alias dl='cd ~/Downloads'
alias grad='cd ~/Desktop/grad_school/ms/second_year/fall'
alias college='cd ~/Desktop/College/'
alias github='cd ~/github'
alias movies='open ~/Library/MATLAB/CS\ 368/'
alias cmu='cd /Users/matthew/Desktop/grad_school/ms/cmu'
alias res='cd /Users/matthew/Desktop/grad_school/ms/first_year/schwartz/TreeDeconvolution'
alias research='res'
alias ml='cd /Users/matthew/Desktop/grad_school/ms/first_year/Spring/ml'
alias docs='cd /Users/matthew/Documents'
alias gen='cd /Users/matthew/Desktop/grad_school/ms/first_year/Spring/quantgen'
alias ds='cd /Users/matthew/Desktop/grad_school/ms/second_year/fall/foundations_of_comp_data_sci'
alias first='cd /Users/matthew/Desktop/grad_school/ms/first_year'
alias cs301='cd /Users/matthew/Desktop/College/4Senior/Fall/cs301'
alias cc='cd /cloud_computing'

# OTHER
alias tweet='python ~/github/theDNABot/tweet.py'
alias calc='~/.calc/prog'
alias DNA='dna'
alias tweetas='tweet_as'
alias obfuscate='bash-obfuscate'
alias graphviz='open http://www.webgraphviz.com/'
alias dsjn='ds >/dev/null && docker run -it -p 8888:8888 --volume "`pwd`:/data" --hostname foundations datasci'
