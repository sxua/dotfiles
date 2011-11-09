source ~/.bash_aliases

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
# export CC=/usr/bin/gcc-4.2
# export CXX=/usr/bin/g++-4.2

if [ -d /opt/local/bin ] && [ -d /opt/local/sbin ]; then

  export PATH=/opt/local/bin:/opt/local/sbin:$PATH
  
  [ -d /opt/local/lib/node_modules ] && export NODE_PATH=/opt/local/lib/node_modules
  
  [ -f /opt/local/etc/bash_completion ] && . /opt/local/etc/bash_completion

fi

[ -d ~/.rbenv/bin ] && export PATH="$HOME/.rbenv/bin:$PATH"
[ -d ~/.rbenv/bin ] && eval "$(rbenv init -)"