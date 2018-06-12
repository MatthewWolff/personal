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
    echo "${blue_op}%{$fg[$color]%}$(battery_pct_remaining)%%${blue_cp}%{$reset_color%}"
  else
    echo "${blue_op}∞${blue_cp}"
  fi
}

local blue_op="%{$fg[blue]%}[%{$reset_color%}"
local blue_cp="%{$fg[blue]%}]%{$reset_color%}"
local path_p="${blue_op}$fg_bold[blue]%~$reset_color${blue_cp}"
local user_host="${blue_op}$fg_bold[white]%n@%m$reset_color${blue_cp}"
local ret_status="${blue_op}%?${blue_cp}"
local hist_no="${blue_op}%h${blue_cp}"
local smiley="${blue_op}%(?,%{$fg[green]%}>:%)%{$reset_color%},%{$fg[red]%}>:(%{$reset_color%})${blue_cp}"

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

RPROMPT='${blue_op}%D{%L:%M:%S}${blue_cp}'
if ! which ioreg | grep -q 'not found'; then # mac only >:)      (see source code @ top for linux)
  PROMPT=$'╭─${path_p}─${user_host}─$(battery_pct_prompt)─${hist_no} $(ssh_connection) $(git_prompt) \n╰─${smiley} > '
else
  PROMPT=$'╭─${path_p}─${user_host}─${hist_no} $(ssh_connection) $(git_prompt) \n╰─${smiley} > ' # forced interpolation for \n
fi
local cur_cmd="${blue_op}%_${blue_cp}"
PROMPT2="${cur_cmd}> "
