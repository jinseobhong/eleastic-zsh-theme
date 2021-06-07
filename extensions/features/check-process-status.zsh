# !/bin/zsh
[[ ! -z $icons ]] && local icons
# Check was there an error about return value
[[ $RETVAL -ne 0 ]] && icons+="%{%F{red}%}$ELASTIC_ICON_PROCESS_IS_ERROR " 
# Check am I root
[[ $UID -eq 0 ]] && icons+="%{%F{yellow}%}$ELASTIC_ICON_PROCESS_IS_ROOT "
# Check is there backgroud jobs
[[ $(jobs -l | wc -l) -gt 0 ]] && icons+="%{%F{cyan}%}$ELASTIC_ICON_PROCESS_IS_BACKGROUND_JOB "