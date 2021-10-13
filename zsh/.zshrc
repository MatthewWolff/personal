export ZSH=$HOME/.oh-my-zsh # ZSH installation path

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

#### USER CONFIGURATION ####
source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # valid command highlighter
export SAVEHIST=999999999
export HISTSIZE=$SAVEHIST
export HISTFILE=~/.zsh_history
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/usr/local/anaconda3/bin:$PATH"
setopt hist_ignore_all_dups
setopt hist_ignore_space


# .VIMRC
touch ~/.vimrc
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

# GIT SETUP
# set up git global ignore if git is present
if command -v git > /dev/null; then
  global_gitignore=$HOME/.config/git/ignore # default loc: https://git-scm.com/docs/gitignore
  mkdir -p $(dirname $global_gitignore)
  if [[ ! -f $global_gitignore ]]; then
    echo $'# Globally Ignored Files\n' > $global_gitignore
    curl -s https://www.toptal.com/developers/gitignore/api/macos,vim,linux,jetbrains+all >> $global_gitignore
  fi

  # set pull method if not already specified
  grep -q 'pull' ~/.gitconfig || git config --global pull.rebase true
fi

#### FUNCTIONS ####
addalias() {
  new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
  echo $new_alias >> ~/.zshrc
  source ~/.zshrc
}
rmalias() {  perl -pi -e "s/^alias $@/# $&/" ~/.zshrc; }
sublime() {  open $@ -a "/Applications/Sublime Text.app/"; }
pycharm() {  open $@ -a "/Applications/PyCharm.app"; }
chrome()  {  open $@ -a "/Applications/Google Chrome.app/"; }
clion()   {  open $@ -a "/Applications/Clion.app"; }
idea()    {  open $@ -a "/Applications/IntelliJ IDEA.app/"; }
settheme() { sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc && source ~/.zshrc; }
cd(){ builtin cd $@ && ls; }
hfs(){ hadoop fs -$*; }

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

use_credentials() {
  [[ -z $1 ]] && echo 'usage: use_credentials [credential file.csv]' && return 1
  [[ ! -f $1 ]] && echo 'invalid file provided' && return 1 
  file=$1
  data=$(cat $file | tail -n1 | sed -E $'s/,/\t/g')
  export AWS_ACCESS_KEY_ID=$(awk '{ print $2 }' <<< $data)
  export AWS_SECRET_ACCESS_KEY=$(awk '{ print $3}' <<< $data)
}


#### ALIASES ####
# UTILITY
alias daddy='sudo'
alias grep='grep --color=auto' 
alias rand='[[ $ZSH_THEME = random ]] || settheme random; source ~/.zshrc'
alias shrink="export RPROMPT=; export PS1=\"$USER > \"" # shrinks the prompt so that it doesnt show the working directory
alias search='grep -rn * -e '
alias ls='ls -G'  # ls -G on mac, ls --color on linux
alias l='ls -lAh'
alias root='su -'
alias self='ssh `networksetup -getcomputername`.local'  # mac only
alias rc='vim ~/.zshrc'
alias src='source ~/.zshrc'

# GIT
alias push='git push -u origin $(git_current_branch)'
alias pull='git pull'
alias gaa='git add --all'
alias 'gcn!'='git commit -v --no-edit --amend'  # retroactively commit files to last commit
alias force='git push -u -f origin $(git_current_branch)'
alias 'oops!'='gaa && gcn! && force'
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

# DOCKER
alias docker_stop='docker rm $(docker ps -a -q)'
alias dls='docker images'
alias drun='docker run -i -t'
alias drm='docker rmi'

# OTHER
alias integrate='curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash'
