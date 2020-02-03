source ./.antigen.zsh

antigen use oh-my-zsh

antigen bundle adb
antigen bundle bundler
antigen bundle command-not-found
antigen bundle common-aliases
antigen bundle cp
antigen bundle gem
antigen bundle git
antigen bundle gpg-agent
antigen bundle gradle
antigen bundle iterm2
antigen bundle osx
antigen bundle pod
antigen bundle rbenv
antigen bundle ruby
antigen bundle sudo
antigen bundle textmate
antigen bundle xcode

antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train

BULLETTRAIN_PROMPT_ORDER=(
  status
  dir
  git
  ruby
)

BULLETTRAIN_PROMPT_SEPARATE_LINE=false
BULLETTRAIN_PROMPT_ADD_NEWLINE=false
BULLETTRAIN_RUBY_PREFIX="💎 "
BULLETTRAIN_GIT_COLORIZE_DIRTY=true
BULLETTRAIN_GIT_BG=green
BULLETTRAIN_GIT_FG=black
BULLETTRAIN_GIT_EXTENDED=false
BULLETTRAIN_GIT_CLEAN=""
BULLETTRAIN_GIT_DIRTY=" \u00b1"
BULLETTRAIN_PROMPT_CHAR=""

antigen apply
