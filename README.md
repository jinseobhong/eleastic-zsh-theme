# Elastic zsh theme

This oh-my-zsh theme was created with reference to agnoster-zsh-theme. The purpose of this theme is to more conveniently customize the functionality of [agnoster-zsh-theme](https://github.com/agnoster/agnoster-zsh-theme) and implement additional extensions. If you want see more information on the theme, refer to [this](https://github.com/agnoster/agnoster-zsh-theme#readme).

A ZSH theme optimized for people who use:
- [Solarized](https://ethanschoonover.com/solarized/)
- [Git](http://git-scm.com/)
- Unicode-compatible fonts and terminals
    - If you use Mac, Install with [iTerm2](https://iterm2.com/) 

# Dependence

This theme has the following package dependencies:

- [zsh](https://www.zsh.org/) ~5.8
    - linux
    - Mac
        - [iTerm2](https://iterm2.com/)
- [oh-my-zsh](https://ohmyz.sh/)
- [Powerline-patched font](https://github.com/powerline/fonts)

# Features


 1. Default agnoster theme's feature  
 2. Easy customization
    - Customize the theme through a preset env file.
 3. Extension
    - Show process working directory(pwd)'s permission.

# Install guide

1. Install zsh
2. Install oh-my-zsh
3. Install Powerline-patched font
4. Check if the font is installed properly
![prompt_segment_icons](https://github.com/jinseobhong/eleastic-zsh-theme/blob/master/assets/prompt_segment_icons.png)
5. Edit ./zshrc
6. Clone this repository in $ZSH_CUSTOM/themes
7. SET DEFAULT SHELL FOR root

# Customize your prompt
By default prompt has these segments: `setStatusPromptSegment`, `setPromptSegmentContext`, `setVirtualenvPromptSegment`, `setDirPromptSegment`, `setVcsPromtSegment`, `setEndOfPromptSegment` in that particular order.

If you want to add, change the order or remove some segments of the prompt, you can use array environment variable named `ELASTIC_PROMPT_SEGMENTS`.

## Usage command
- Show all segments of the prompt with indices:  
  ``` 
  echo "${(F)ELASTIC_PROMPTT_SEGMENTS[@]}" | cat -n 
  ```
- Add the new segment of the prompt to the beginning: 
  ``` 
  ELASTIC_PROMPT_SEGMENTS=(setVcsPromtSegment ${ELASTIC_PROMPT_SEGMENTS[@]})
  ```
- Add the new segment of the prompt to the end: 
  ``` 
  ELASTIC_PROMPT_SEGMENTS+=setEndOfPromptSegment
  ```
- Insert the new segment of the prompt = `PROMPT_SEGMENT_NAME` on the particular position = `PROMPT_SEGMENT_POSITION`:
  ```
  PROMPT_SEGMENT_POSITION=5 PROMPT_SEGMENT_NAME="setEndOfPromptSegment";\
  ELASTIC_PROMPT_SEGMENTS=("${ELASTIC_PROMPT_SEGMENTS[@]:0:$PROMPT_SEGMENT_POSITION-1}" "$PROMPT_SEGMENT_NAME" "${ELASTIC_PROMPT_SEGMENTS[@]:$PROMPT_SEGMENT_POSITION-1}");\
  unset PROMPT_SEGMENT_POSITION PROMPT_SEGMENT_NAME
  ```
- Insert the new segment of the prompt = `PROMPT_SEGMENT_NAME` on the particular position = `PROMPT_SEGMENT_POSITION`:
  ```
  SWAP_SEGMENTS=(4 5);\
  TMP_VAR="$ELASTIC_PROMPT_SEGMENTS[$SWAP_SEGMENTS[1]]"; ELASTIC_PROMPT_SEGMENTS[$SWAP_SEGMENTS[1]]="$ELASTIC_PROMPT_SEGMENTS[$SWAP_SEGMENTS[2]]"; ELASTIC_PROMPT_SEGMENTS[$SWAP_SEGMENTS[2]]="$TMP_VAR"
  unset SWAP_SEGMENTS TMP_VAR
  ```
- Remove the 5th segment:
  ```
  ELASTIC_PROMPT_SEGMENTS[5]=
  ```
