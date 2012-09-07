ZSH=$HOME/.oh-my-zsh

brewbin=/usr/local/bin
if [ -d $brewbin ]; then
  export PATH=$brewbin:/usr/local/sbin:/usr/local/share/python:$(echo $PATH | sed -E "s%$brewbin:?%%")
fi
if [ -f $brewbin/rbenv ]; then
  eval "$(rbenv init -)"
fi

export RBX_ROOT=$HOME/.rbenv/versions/rbx-2.0.0-dev
export PATH=/usr/local/Cellar/ruby/1.9.3-p194/bin:$RBX_ROOT/gems/1.9/bin:$PATH
export NODE_PATH=/usr/local/lib/node_modules

if [ -d $ZSH ]; then
  CASE_SENSITIVE="true"
  COMPLETION_WAITING_DOTS="true"

  plugins=(brew git osx heroku rails3 rbenv)
    
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

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[white]%}@"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}%{$fg[yellow]%}"

# show git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

# show red star if there are uncommitted changes
parse_git_dirty() {
  if git diff-index --quiet HEAD 2> /dev/null; then
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  else
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi
}

# Formats prompt string for current git commit short SHA
git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# if in a git repo, show dirty indicator + git branch
git_custom_status() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX${git_where#(refs/heads/|tags/)}$(git_prompt_short_sha)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# show current rbenv version if different from rbenv global
rbenv_version_status() {
  local ver=$(rbenv version-name)
  if [ "$(rbenv global)" != "$ver" ]; then
    echo "%{$fg[red]%}[$ver]%{$reset_color%}"
  else
    echo "%{$fg[green]%}໐%{$reset_color%}%{$fg[red]%}[%{$reset_color%}%{$fg[red]%}$ver]%{$reset_color%}"
  fi
}

# put fancy stuff on the right
if which rbenv &> /dev/null; then
  RPS1='$(git_custom_status)$(rbenv_version_status) $EPS1'
else
  RPS1='$(git_custom_status) $EPS1'
fi

PROMPT='%{$fg[cyan]%}%~% %(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
