source ~/.bash_aliases

if [ $(uname) == 'Darwin' ]; then
  export CLICOLOR=1
  export LSCOLORS=ExFxCxDxBxegedabagacad
  export EDITOR=/usr/bin/mate
  export PATH=$HOME/bin:$PATH
  export NODE_PATH=/usr/local/lib/node_modules
  if [ -d /usr/local/bin ] && [ -d /usr/local/sbin ]; then export PATH=/usr/local/bin:/usr/local/sbin:$PATH; fi
  if [ -d /Applications/Adobe/Adobe\ Flash\ Builder\ 4.5/sdks/3.0.0 ]; then export PATH=/Applications/Adobe/Adobe\ Flash\ Builder\ 4.5/sdks/3.0.0/bin:$PATH; fi
  if [ -d /usr/local/lib/node_modules ]; then export PATH=/usr/local/lib/node_modules:$PATH; fi
  eval "$(rbenv init -)"
else
  export LC_CTYPE=en_US.UTF-8
  umask 002
fi
