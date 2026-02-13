# ============================================================================
# OH-MY-ZSH CONFIGURATION
# ============================================================================

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="wolffy"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" "clean" "wolffy")

DISABLE_AUTO_TITLE="false"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  battery
  aws
  zsh-autosuggestions
  colored-man-pages
)

# ============================================================================
# USER CONFIGURATION
# ============================================================================

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History
export SAVEHIST=999999999
export HISTSIZE=$SAVEHIST
export HISTFILE=~/.zsh_history
setopt hist_ignore_all_dups
setopt hist_ignore_space

# Path
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$HOME/.toolbox/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

# SSH
CLOUD_DESKTOP=cloudminion.aka.corp.amazon.com

# ============================================================================
# VIMRC SETUP
# ============================================================================

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

# ============================================================================
# GIT SETUP
# ============================================================================

# use delta as pager if present
command -v delta > /dev/null && export GIT_PAGER="delta" || :

# set up git global ignore if git is present
global_gitignore=$HOME/.config/git/ignore # default loc: https://git-scm.com/docs/gitignore

if [[ ! -f $global_gitignore ]] && command -v git > /dev/null; then
  mkdir -p $(dirname $global_gitignore)
  echo $'# Globally Ignored Files\n' > $global_gitignore
    cat >> $global_gitignore << 'IGNORE'
build
node_modules
annotation-generated-src
*.iml
IGNORE
  
  if ! curl -sf https://www.toptal.com/developers/gitignore/api/macos,vim,linux,jetbrains+all >> $global_gitignore; then
    echo "Warning: Failed to fetch gitignore templates" >&2
  fi

  # set pull method if not already specified
  git config --global init.defaultBranch main
  git config --global fetch.prune true           # auto-prune deleted remote branches
  git config --global pull.rebase true

  # delta configs (if available)
  if command -v delta > /dev/null; then
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
  else
    echo "Warning: delta not installed. Install with: brew install git-delta" >&2
  fi
fi

# ============================================================================
# FUNCTIONS
# ============================================================================

addalias() {
  new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
  echo $new_alias >> ~/.zshrc
  source ~/.zshrc
}

swap() {
  mv "$1" "$1.swp"
  mv "$2" "$1"
  mv "$1.swp" "$2"
  echo "swapped $1 and $2"
}

chrome() { open "$@" -a "/Applications/Google Chrome.app/"; }
idea() { open "$@" -a "$HOME/Applications/IntelliJ IDEA.app"; }
pycharm() { open "$@" -a "$HOME/Applications/PyCharm.app"; }
rmalias() { perl -pi -e "s/^alias $@/# $&/" ~/.zshrc; }
settheme() { sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc && source ~/.zshrc; }
sublime() { open "$@" -a "/Applications/Sublime Text.app/"; }

# ============================================================================
# ALIASES - UTILITY
# ============================================================================

alias daddy='sudo'
alias find_large="du -sh * 2>/dev/null | grep -E '^[[:space:]]*[0-9]+(\.[0-9]+)?G'"
alias ggrep='ggrep --color=auto'
alias grep='grep --color=auto'
alias l='ls -lAh'
alias ls='ls --color'
alias rand='[[ $ZSH_THEME = random ]] || settheme random; source ~/.zshrc'
alias rc='vim ~/.zshrc'
alias root='su -'
alias searchall='grep -rn $PWD/* -e'
alias self='ssh `networksetup -getcomputername`.local'
alias shrink="export RPROMPT=; export PS1=\"$USER > \""
alias src='source ~/.zshrc'

# ============================================================================
# ALIASES - GIT
# ============================================================================

alias force='git push -u -f origin $(git_current_branch)'
alias gaa='git add --all'
alias 'gcn!'='git commit -v --no-edit --amend'
alias gdc='git diff --cached'
alias gits='git status'
alias gitup='git branch --set-upstream-to=origin/mainline $(git rev-parse --abbrev-ref HEAD)'
alias gl="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
alias glh='git log | head'
alias pull='git pull origin $(git_current_branch)'
alias push='git push -u origin $(git_current_branch)'

# ============================================================================
# ALIASES - SPOTIFY
# ============================================================================

# Controls
alias c='spotify status; spotify share | head -n 2'
alias n='next'
alias next='spotify next'
alias p='spotify prev'
alias play='spotify play'
alias shuf='spotify toggle shuffle'
alias skip='spotify next'
alias song='spotify status'
alias spotify='if ! pgrep -x "Spotify" > /dev/null; then open /Applications/Spotify.app/ --background; sleep 3; fi; spotify'
alias vd='spotify vol $(( $(spotify vol | perl -nle "print $& if m{[0-9]{1,2}(?=\.)}") - 9 ))'
alias vu='spotify vol $(( $(spotify vol | perl -nle "print $& if m{[0-9]{1,2}(?=\.)}") + 11 ))'

# Playlists
alias daylist='spotify play uri spotify:playlist:37i9dQZF1EP6YuccBxUcC1 >/dev/null && echo playing daylist'
alias disc='spotify play uri spotify:playlist:37i9dQZEVXcHX1sGVICYXF >/dev/null && echo playing discovery playlist...'
alias hardstyle='spotify play uri spotify:playlist:31ot9dglNeVWIXwNZ7c3TG >/dev/null && echo playing Hardstyle...'
alias jazz='music && sleep 5 && spotify play uri spotify:playlist:37i9dQZF1DWVqfgj8NZEp1'
alias shiloh='spotify play uri spotify:playlist:7qd17uUKPGKXXDzSLMu9dJ >/dev/null && echo playing shiloh dynasty...'
alias tech='spotify play uri spotify:playlist:37i9dQZF1DX0r3x8OtiwEM >/dev/null && echo playing Lowkey Tech...'
alias werk='spotify play uri spotify:playlist:0c4qVPXwIarAIOIPsgI0Gp >/dev/null && echo playing werk playlist...'

# Artists & Albums
alias e='eden'
alias eden='spotify play uri spotify:artist:1t20wYnTiAT0Bs7H1hv9Wt >/dev/null && echo playing eden...'
alias interstellar='spotify play uri spotify:album:3N8fGhRcHWqyy0SfWa92H0 >/dev/null && echo playing interstellar soundtrack...'
alias m='moderat'
alias moderat='spotify play uri spotify:playlist:1DWC6bqpH4fYVTrwEmOuvb >/dev/null && echo playing moderat...'
alias x=xxx
alias xxx='spotify play uri spotify:artist:15UsOTVnJzReFVN1VCnxy4 >/dev/null && echo playing xxxTentacion...'

# ============================================================================
# ALIASES - DOCKER
# ============================================================================

alias dls='docker images'
alias docker_stop='docker rm $(docker ps -a -q)'
alias drm='docker rmi'
alias drun='docker run -i -t'
alias dclean='docker system prune -f'

# ============================================================================
# MODERN CLI TOOLS (if installed)
# ============================================================================

# eza (modern ls) - https://github.com/eza-community/eza
if command -v eza > /dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias l='eza -lah --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
  alias la='eza -lah --icons --group-directories-first'
fi

# bat (better cat) - https://github.com/sharkdp/bat
if command -v bat > /dev/null; then
  alias cat='bat --style=plain --paging=never'
  alias ccat='bat'
fi

# ripgrep (better grep) - https://github.com/BurntSushi/ripgrep
if command -v rg > /dev/null; then
  alias search='rg --smart-case'
fi

# fd (better find) - https://github.com/sharkdp/fd
if command -v fd > /dev/null; then
  alias find='fd'
fi

# fzf (fuzzy finder) - https://github.com/junegunn/fzf
if command -v fzf > /dev/null; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

  # Default options
  export FZF_DEFAULT_OPTS='
    --height 40%
    --reverse
    --border
    --inline-info
    --color=fg:-1,bg:-1,hl:#5f87af
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
    --bind=ctrl-u:preview-page-up,ctrl-d:preview-page-down
  '

  # Use ripgrep for file search (respects .gitignore)
  if command -v rg > /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  # Use fd for directory search
  if command -v fd > /dev/null; then
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi

  # Preview files with bat
  if command -v bat > /dev/null; then
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
  fi
fi

# zoxide (smarter cd) - https://github.com/ajeetdsouza/zoxide
if command -v zoxide > /dev/null; then
  eval "$(zoxide init zsh)"
  cd() { z "$@" && ls; }
else
  cd() { builtin cd "$@" && ls; }
fi

# ============================================================================
# WORK - FUNCTIONS
# ============================================================================

auth() {
  #/usr/bin/kinit -f --keychain
  PASS=$(security find-generic-password -w -s 'midway-manual' -a $USER)
  echo -ne "$PASS\n" | mwinit -s --fido2
}

ada_assume() {
  local account=""
  local two_pr=""
  local read_only=""

  while [[ $# -gt 0 ]]; do
    case $1 in
      --2pr)
        two_pr="$2"
        # Extract UUID from URL if it's a URL
        if [[ $two_pr == *"/"* ]]; then
          two_pr=$(echo "$two_pr" | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')
        fi
        shift 2
        ;;
      --read-only)
        read_only="--conduit-read-only"
        shift
        ;;
      *)
        account="$1"
        shift
        ;;
    esac
  done

  if [[ -n $two_pr ]]; then
    echo ada cred update --account=$account --provider=conduit --role=IibsAdminAccess-DO-NOT-DELETE --once --2pr=$two_pr $read_only
    ada cred update --account=$account --provider=conduit --role=IibsAdminAccess-DO-NOT-DELETE --once --2pr=$two_pr $read_only
  else
    ada cred update --account=$account --provider=conduit --role=IibsAdminAccess-DO-NOT-DELETE --once $read_only
  fi
}

assume_role() {
  eval $(aws sts assume-role --role-arn $1 --role-session-name test | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nexport AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nexport AWS_SESSION_TOKEN=\(.SessionToken)\n"')
}

ecr-login() {
  if [[ -z $1 ]]; then
    echo "usage: ecr-login <account-id,name> [region: us-east-1 (default)]" >&2
    return
  fi
  account=$1
  region=${2:-us-east-1}
  aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $account.dkr.ecr.$region.amazonaws.com
}

ninja-add() {
  ninja-dev-sync -add $HOME/workplace/$1 -add-host $CLOUD_DESKTOP -add-remote /home/$USER/workplace/$1 -unsafe
}

notes() {
  if [[ -z $1 ]]; then
    cat ~/.notes;
  else
    echo "$(date) -- $*" >> ~/.notes
  fi
}

# ============================================================================
# WORK - ALIASES
# ============================================================================

alias bb='nocorrect brazil-build'
alias bb-all='brazil-recursive-cmd --allPackages brazil-build'
alias bb-clean='brazil-recursive-cmd --allPackages brazil-build clean'
alias bbr='brazil-recursive-cmd brazil-build'
alias bws='brazil ws'
alias cloud="ssh $CLOUD_DESKTOP"
alias kinit=/usr/bin/kinit
alias ndr='ninja-dev-sync -remove'
alias nds=ninja-dev-sync
alias ndsl='nds -list'
alias ndsr='nds -remove '
alias sam='brazil-build-tool-exec sam'
alias update='bws sync -md; brazil-recursive-cmd "git pull --autostash" --allPackages'

# ============================================================================
# EXPORTS & SOURCES
# ============================================================================

source "$HOME/.brazil_completion/zsh_completion"

export PATH="$PATH:/opt/homebrew/anaconda3/bin"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)" # explicitly use java 1.8
export PATH="$JAVA_HOME/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# ============================================================================
# INTEGRATIONS
# ============================================================================

# iTerm2
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

# Kiro CLI
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" || :
