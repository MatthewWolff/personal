# Created by Matthew Wolff (https://matthewwolff.github.io — https://github.com/MatthewWolff/Scraps/blob/master/zsh/wolffy.zsh-theme)
# Uses code from the battery plugin (https://github.com/MatthewWolff/oh-my-zsh/blob/master/plugins/battery/battery.plugin.zsh)
# Is a heavily modified form of Tessilo's prompt (http://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/)

function battery_pct_prompt () {
  if [[ $(ioreg -rc AppleSmartBattery | grep -c '^.*"ExternalConnected"\ =\ No') -eq 1 ]] ; then
    b=$(battery_pct_remaining)
    if [ $b -gt 50 ] ; then
      color='green'
    elif [ $b -gt 20 ] ; then
      color='yellow'
    else
      color='red'
    fi
    echo "${op}%{$fg[$color]%}$(battery_pct_remaining)%%${cp}%{$reset_color%}"
  else
    echo "${op}∞${cp}"
  fi
}

local op="%{$fg[white]%}[%{$fg[green]%}"
local cp="%{$fg[white]%}]%{$fg[green]%}"
local path_p="${op}$fg_bold[blue]%~$reset_color${cp}"
local user_host="${op}$fg_bold[white]%n@%m$reset_color${cp}"
local ret_status="${op}%?${cp}"
local hist_no="${op}%h${cp}"
local smiley="${op}%(?,%{$fg[green]%}>:%)%{$reset_color%},%{$fg[red]%}>:(%{$reset_color%})${cp}"

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh)%{$reset_color%} "
  fi
}

function git_prompt() {
  if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    gitprompt=$(sed "s/:/ /" <<< `git_prompt_info` | sed "s/[()]//g")
    repo=$(basename `git rev-parse --show-toplevel`)
    echo "%{$fg[yellow]%}($gitprompt $repo)%{$reset_color%} "
  fi
}

RPROMPT='${op}%D{%L:%M:%S}${cp}'
PROMPT=$'$fg[green]╭─${path_p}─${user_host}─$(battery_pct_prompt)─${hist_no} $(ssh_connection) $(git_prompt) \n$fg[green]╰─${smiley} > '
local cur_cmd="${op}%_${cp}"
PROMPT2="${cur_cmd}> "
