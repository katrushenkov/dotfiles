#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ll="ls -la"
PS1='[\u@\h \W]\$ '

[ -f ~/.config/fzf.bash ] && source ~/.config/fzf.bash
