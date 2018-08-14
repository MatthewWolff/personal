export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="wolffy"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array has no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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

#### USER CONFIGURATION
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Valid command highlighter
source $ZSH/oh-my-zsh.sh
export SAVEHIST=1000000

#### FUNCTIONS
addalias()
{
        new_alias="alias $(echo $1 | sed -e "s/=/='/" -e "s/$/'/")"
        echo $new_alias >> ~/.zshrc
        source ~/.zshrc
}
settheme()
{
    sed -i '' -e "s/ZSH_THEME=\"[a-z]*\"/ZSH_THEME=\"$1\"/" ~/.zshrc
    source ~/.zshrc
}
sublime()
{
  open "$@" -a "/Applications/Sublime Text.app"
}
pycharm()
{
  open "$@" -a "/Applications/PyCharm.app"
}
cd(){ builtin cd $@ && ls; }
hfs(){ hadoop fs -$*; }

#### ALIASES
alias daddy='sudo'
alias theme='source ~/.zshrc' # picks a random theme if curr theme is "random"
alias rand='[[ $ZSH_THEME = random ]] || settheme random; source ~/.zshrc'
alias shrink='export PS1="\u > "' # temporarily shrinks the prompt so that it doesn't show the working directory
alias search='grep -rwn * -e '
alias push='git push -u origin master'
alias pull='git pull'
alias gaa='git add --all'
alias 'gcn!'='git commit -v --no-edit --amend'  # retroactively commit files to last commit
alias force='git push -u -f origin master'
alias 'oops!'='gaa && gcn! && force'
alias gits='git status'
alias ls='ls -G'  # ls -G on mac, ls --color on linux
alias grep='grep --color=auto' 
alias hstart='/usr/local/Cellar/hadoop/3.0.0/sbin/start-dfs.sh;/usr/local/Cellar/hadoop/3.0.0/sbin/start-yarn.sh'
alias hstop='/usr/local/Cellar/hadoop/3.0.0/sbin/stop-yarn.sh;/usr/local/Cellar/hadoop/3.0.0/sbin/stop-dfs.sh'
alias self='ssh `networksetup -getcomputername`.local'  # mac only
alias rc='vim ~/.zshrc'
alias src='source ~/.zshrc'
alias root='su -'
alias l='ls -lAh'
