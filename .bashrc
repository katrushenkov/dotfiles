#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

export HISTCONTROL=ignoreboth:erasedups

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

shopt -s autocd		# change to named directory
shopt -s cdspell	# autocorrects cd misspellings
shopt -s cmdhist	# save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend	# do not overwrite history
shopt -s expand_aliases # expand aliases

#vi-mode
#set -o vi

#create a file called .bashrc-personal and put all your personal aliases
#in there. They will not be overwritten by skel.
#[[ -f ~/.bashrc-personal ]] && . ~/.bashrc-personal

#stty -ixon # Disable ctrl-s and ctrl-q

# Start graphical server if i3 not already running
#if [ "$(tty)" = "/dev/tty1" ]; then
#    pgrep -x i3 || exec startx
#fi
