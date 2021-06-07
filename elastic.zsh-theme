# !/bin/zsh
# vim:ft=zsh ts=2 sw=2 sts=2
#
# Sumaary
#
# It was made by referring to the following [source](https://gist.github.com/3712874)
# It has been modified by the following author: [jinseobhong](https://github.com/jinseobhong)
# This source is served this [git repository](https://github.com/jinseobhong/extenstion-agnoster-zsh-theme)
# 
# Dependence
# [Powerline-patched font](https://gist.github.com/1595572
#
# Extension
# 
## - Show process working directory(pwd) permission.

# Check ZSH_THEME_PATH directory and import theme enviroments
[[ -z $ZSH_THEME_PATH ]] && $ZSH_THEME_PATH=$ZSH_CUSTOM/themes
if [[ -d $ZSH_THEME_PATH ]]; then
  if [[ -e $ZSH_THEME_PATH/$ZSH_THEME.zsh-env ]]; then
    ELASTIC_ENVIROMENTS=$ZSH_THEME_PATH/$ZSH_THEME.zsh-env
    source $ELASTIC_ENVIROMENTS
  else
    echo " Error : Don't import zsh theme's enviroment file"
    exit 0
  fi
  if [[ -d $ZSH_THEME_PATH/extensions ]]; then
    ELASTIC_EXTENSION=$ZSH_THEME_PATH/extensions
  else
    echo " Error : Don't find zsh theme's extension directory"
    exit 0
  fi
fi

# Segments of the prompt, default order declaration
if [[ ! -n $ELASTIC_PROMPT_SEGMENTS ]]; then
  typeset -aHg ELASTIC_PROMPT_SEGMENTS=(
      setStatusPromptSegment
      setPromptSegmentContext
      setVirtualenvPromptSegment
      setDirPromptSegment
      setVcsPromtSegment
      setEndOfPromptSegment
  )
fi

# Segment drawing
# Rendering default background/foreground.
setPromptSegment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $ELASTIC_CURRENT_PROMPT_SEGMENT_BACKGROUND_COLOR != $ELASTIC_DEFAULT_PROMPT_SEGMENT_BACKGROUND_COLOR ]]; then
      print -n "%{$bg%F{$ELASTIC_CURRENT_PROMPT_SEGMENT_BACKGROUND_COLOR}%}$ELASTIC_ICON_SEGMENT_SEPARATOR%{$fg%} "
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  ELASTIC_CURRENT_PROMPT_SEGMENT_BACKGROUND_COLOR=$1
  [[ -n $3 ]] && print -n $3
}

# Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Status :
# - was there an error
# - am I root
# - are there background jobs?
setStatusPromptSegment() {
  # Check latest process status
  source $ELASTIC_EXTENSION/features/check-process-status.zsh
  setPromptSegment $ELASTIC_DEFAULT_PROMPT_SEGMENT_FOREGROUND_COLOR $ELASTIC_DEFAULT_PROMPT_SEGMENT_BACKGROUND_COLOR "$icons"
}

# Context: user@hostname (who am I and where am I)
setPromptSegmentContext() {
  if [[ whoami != $DEFAULT_USER || -n $SSH_CONNECTION ]]; then
    setPromptSegment $ELASTIC_DEFAULT_PROMPT_SEGMENT_FOREGROUND_COLOR $ELASTIC_DEFAULT_PROMPT_SEGMENT_BACKGROUND_COLOR "$ELASTIC_PROMPT_SEGMENT_CONTEXT"
  fi
}

# Display current virtual environment
setVirtualenvPromptSegment() {
  if [[ -n $VIRTUAL_ENV ]]; then
    setPromptSegment $ELASTIC_VIRTUAL_ENVIROMENT_BACKGROUND_COLOR $ELASTIC_VIRTUAL_ENVIROMENT_FOURGROUND_COLOR "$(basename $VIRTUAL_ENV) "
  fi
}

# Directory : current working directory
setDirPromptSegment() {
  # Check current working directory's permission
  source $ELASTIC_EXTENSION/features/check-pwd-permission.zsh
  setPromptSegment $ELASTIC_DIRECOTRY_BACKGROUND_COLOR $ELASTIC_DIRECOTRY_FOREGROUND_COLOR "$icons $pwd_owner_user:$pwd_owner_group %~ "
}

# Git: check stage status is dirty, check work directory is branch, check detached from head
setVcsPromtSegment() {
  local isHEAD isClean vcs_icon_branch vcs_icon_stage_status vcs_prompt_context
  # If current working directory is git work tree
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
      vcs_info
      # Check current work tree is diffrent from HEAD
      if [[ ! "$(git diff HEAD)" ]]; then
        isHEAD=true
      else
        isHEAD=false
      fi
      # Check current work tree's stage status
      if [[ ! "$(git status --porcelain --ignore-submodules)" ]]; then
        isClean=true
      else
        isClean=false
      fi
      vcs_prompt_segment_context=$vcs_info_msg_0_
      # If current worktree is detached from HEAD
      if $isHEAD; then
        vcs_icon_branch+="$ELASTIC_ICON_BRANCH_IS_HEAD"
      else
        vcs_icon_branch+="$ELASTIC_ICON_BRANCH_IS_DETACHED"
      fi
      # If current work tree's stage is clean.
      if $isClean; then
        [[ -z $ELASTIC_VCS_PROMPT_SEGMENT_COLOR ]] && 
        ELASTIC_VCS_PROMPT_SEGMENT_COLOR=$ELASTIC_VCS_BACKGROUND_COLOR_IS_CLEAN
       
      else
        [[ -z $ELASTIC_VCS_PROMPT_SEGMENT_COLOR ]] &&
         vcs_icon_stage_status=$ELASTIC_ICON_STAGE_IS_DIRTY
        ELASTIC_VCS_PROMPT_SEGMENT_COLOR=$ELASTIC_VCS_BACKGROUND_COLOR_IS_NOT_CLEAN
      fi
      setPromptSegment $ELASTIC_VCS_PROMPT_SEGMENT_COLOR $ELASTIC_DEFAULT_PROMPT_SEGMENT_FOREGROUND_COLOR "$vcs_icon_branch $vcs_prompt_segment_context $vcs_icon_stage_status "
  fi
}

# End of prompt segment, closing any open segments
setEndOfPromptSegment() {
  if [[ -n $ELASTIC_CURRENT_PROMPT_SEGMENT_BACKGROUND_COLOR ]]; then
    print -n "%{%k%F{$ELASTIC_CURRENT_PROMPT_SEGMENT_BACKGROUND_COLOR}%}$ELASTIC_ICON_SEGMENT_SEPARATOR "
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
}


# get Prompt Segments
getPromptSegment() {
  RETVAL=$?
  for setPromptSegment in ${ELASTIC_PROMPT_SEGMENTS[@]}; 
  do
    [[ -n $setPromptSegment ]] && $setPromptSegment
  done
}

# Set pre
setPrecmd() {
  PROMPT='%{%f%b%k%}$(getPromptSegment)'
}

# Set about prompt
setPrompt() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info
  prompt_opts=(cr subst percent)
  add-zsh-hook precmd setPrecmd
  
  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes fals
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

setPrompt $@