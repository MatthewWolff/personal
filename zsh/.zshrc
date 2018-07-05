export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="wolffy"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git battery
)

source $ZSH/oh-my-zsh.sh

#### USER CONFIGURATION

source ~/.oh-my-zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Valid command highlighter

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

#### FUNCTIONS
addalias()
{
        new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
        echo $new_alias >> ~/.bashrc
        echo $new_alias >> ~/.zshrc
        source ~/.bashrc; source ~/.zshrc # order matters
}
settheme()
{
    sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc
    source ~/.zshrc
}
cd(){ builtin cd $@ && ls; }
hfs(){ hadoop fs -$*; }

#### ALIASES
alias theme='source ~/.zshrc' # picks a random theme if curr theme is "random"
alias rand='settheme random; source ~/.zshrc'
alias shrink='export PS1="\u > "' # temporarily shrinks the prompt so that it doesn't show the working directory
alias search='grep -rwn * -e '
alias push='git push -u origin master'
alias pull='git pull'
alias ls='ls --color'  # ls -G on mac
alias daddy='sudo'
alias grep='grep --color=auto' 
alias hstart='/usr/local/Cellar/hadoop/3.0.0/sbin/start-dfs.sh;/usr/local/Cellar/hadoop/3.0.0/sbin/start-yarn.sh'
alias hstop='/usr/local/Cellar/hadoop/3.0.0/sbin/stop-yarn.sh;/usr/local/Cellar/hadoop/3.0.0/sbin/stop-dfs.sh'
alias ha='hstart'
alias ho='hstop'
alias self='ssh `networksetup -getcomputername`.local'  # mac only?
alias rc='vim ~/.zshrc'
