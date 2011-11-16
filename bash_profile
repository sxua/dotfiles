source ~/.bash_aliases

if [ $(uname) == 'Darwin' ]; then
  export CLICOLOR=1
  export LSCOLORS=ExFxCxDxBxegedabagacad
  # export CC=/usr/bin/gcc-4.2
  # export CXX=/usr/bin/g++-4.2

  if [ -d /opt/local/bin ] && [ -d /opt/local/sbin ]; then

    export PATH=/opt/local/bin:/opt/local/sbin:/opt/local/lib/postgresql90/bin/:$PATH
  
    [ -d /opt/local/lib/node_modules ] && export NODE_PATH=/opt/local/lib/node_modules
  
    [ -f /opt/local/etc/bash_completion ] && . /opt/local/etc/bash_completion

  fi

  [ -d ~/.rbenv/bin ] && export PATH="$HOME/.rbenv/bin:$PATH"
  [ -d ~/.rbenv/bin ] && eval "$(rbenv init -)"
else
  export LC_CTYPE=en_US.UTF-8
  umask 002
fi