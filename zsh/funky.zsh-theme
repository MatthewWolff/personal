# Taken from Tassilo's Blog
# http://tsdh.wordpress.com/2007/12/06/my-funky-zsh-prompt/
# Edited by Matthew Wolff (https://matthewwolff.github.io)

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
local smiley="%(?,%{$fg[green]%}>:%)%{$reset_color%},%{$fg[red]%}>:(%{$reset_color%})"
function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh)%{$reset_color%} "
  fi
}
RPROMPT='[%D{%L:%M:%S}]'
PROMPT="╭─${path_p}─${user_host}─%{$(battery_pct_prompt)%}─${hist_no} $(ssh_connection)
╰─${blue_op}${smiley}${blue_cp} > "
local cur_cmd="${blue_op}%_${blue_cp}"
PROMPT2="${cur_cmd}> "
