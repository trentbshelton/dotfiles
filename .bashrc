# ~/.bashrc
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

export PATH="$HOME/.local/bin:$PATH"

eval "$(starship init bash)"
fastfetch
