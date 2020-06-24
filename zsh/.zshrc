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
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Valid command highlighter
source $ZSH/oh-my-zsh.sh
export SAVEHIST=1000000

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
settheme() { sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc && source ~/.zshrc; }
cd(){ builtin cd $@ && ls; }
hfs(){ hadoop fs -$*; }

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
alias spotify='if ! pgrep -x "Spotify" > /dev/null; then
	       open /Applications/Spotify.app/ --background; sleep 3; fi; spotify'
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

# HADOOP
alias hstart='/usr/local/Cellar/hadoop/3.0.0/sbin/start-dfs.sh;/usr/local/Cellar/hadoop/3.0.0/sbin/start-yarn.sh'
alias hstop='/usr/local/Cellar/hadoop/3.0.0/sbin/stop-yarn.sh;/usr/local/Cellar/hadoop/3.0.0/sbin/stop-dfs.sh'

# DOCKER
alias docker_stop='docker rm $(docker ps -a -q)'
alias dls='docker images'
alias drun='docker run -i -t'
alias drm='docker rmi'
