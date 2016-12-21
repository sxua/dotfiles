ZSH=$HOME/.oh-my-zsh

brewbin=/usr/local/bin
if [ -d $brewbin ]; then
  export PATH=$brewbin:/usr/local/sbin:$(echo $PATH | sed -E "s%$brewbin:?%%")
fi
if [ -f $brewbin/rbenv ]; then
  eval "$(rbenv init -)"
fi

export MACOSX_DEPLOYMENT_TARGET=10.11
export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.12.sdk/

export PATH=/usr/local/share/npm/bin:$PATH
export NODE_PATH=/usr/local/lib/node_modules
export NVM_DIR=~/.nvm
# source $(brew --prefix nvm)/nvm.sh

export PATH=~/.android/sdk/ndk-bundle:~/.android/sdk/platform-tools:$PATH

if [ -d $ZSH ]; then
  CASE_SENSITIVE="false"
  COMPLETION_WAITING_DOTS="true"

  plugins=(brew bundler colored-man cp extract gem osx pod textmate)
    
  for plugin ($plugins); do
    fpath=($ZSH/plugins/$plugin $fpath)
  done
  
  autoload -U compinit
  compinit -i
  
  for plugin ($plugins); do
    if [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
      source $ZSH/plugins/$plugin/$plugin.plugin.zsh
    fi
  done
  
  for config_file (completion history); do
    source $ZSH/lib/$config_file.zsh
  done
fi

[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"
setopt prompt_subst

ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export GPG_TTY=`tty`

CURRENT_BG='NONE'
PRIMARY_FG=black

# Characters
SEGMENT_SEPARATOR="\ue0b0"
PLUSMINUS="\u00b1"
BRANCH="\ue0a0"
DETACHED="\u27a6"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    print -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    print -n "%{%k%}"
  fi
  print -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref
  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -Pn " $ref"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue white ' %~ '
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$CROSS"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $PRIMARY_FG default " $symbols "
}

# Display current virtual environment
prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn " $(basename $VIRTUAL_ENV) "
  fi
}

# put fancy stuff on the right
prompt_rbenv() {
  local ref
  if which rbenv &> /dev/null; then
    ref=" 💎  %{%F{white}%}$(rbenv version-name)"
    prompt_segment red $PRIMARY_FG
    print -Pn "$ref "
  fi
}

## Main prompt
prompt_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  prompt_status
  prompt_virtualenv
  prompt_dir
  prompt_git
  prompt_rbenv
  prompt_end
}

prompt_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_main) '
}

prompt_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_setup "$@"