
setopt +o nomatch	# fix for youtube-dl aliases
setopt autocd		  # Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Handle CTRL-S lock
stty -ixon

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTCONTROL=ignoredups:erasedups
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh-personal" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh-personal"

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# yazi shell wrapper for changing cwd when exiting
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Change cursor shape for different vi modes.
function zle-keymap-select () {
     case $KEYMAP in
	     vicmd) echo -ne '\e[1 q';;      # block
	     viins|main) echo -ne '\e[5 q';; # beam
     esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

mkcd () {
     mkdir -p "$*"
     cd "$*"
}

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        #echo "nnn is already running"
	      exit
    return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    # NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

nsel () {
    tr '\0' '\n' < "${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection"
}

export NNN_USE_EDITOR=1
export NNN_OPTS='acdAHU'
#export NNN_PLUG='n:-_vim ~/Dropbox/Public/Docs/Notes/note*;o:fzopen;p:mocplay;d:diffs;t:nmount;m:-_mediainfo $nnn;s:_smplayer -minigui $nnn*;c:fzcd;a:-_mocp*;y:-_sync*;k:-_fuser -kiv $nnn*;t:-!|tree -ps;e:-_ewrap $nnn*'
export NNN_PLUG='o:finder;f:fzcd;x:fzopen;t:nmount;v:imgview;g:bookmarks;G:cdpath;i:preview-tabbed;w:preview-tui;e:preview-tui;c:getplugs;z:imgresize;d:diffs;b:boom;q:cdpath;p:imgresize;j:cdpath;h:dups;k:pskill;l:nmount;m:-!mediainfo $nnn;a:rsynccp;u:togglex;n:fzplug'
export NNN_OPENER=${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins/nuke
#export NNN_BMS='a:/mnt/main/sync/anima;h:~;v:/mnt/main/vid;c:~/.config'
export NNN_FIFO='/tmp/nnn.fifo' # temporary buffer for previews
export NNN_SSHFS="sshfs -o follow_symlinks,reconnect,auto_cache"
export SPLIT='v' # to split Kitty vertically
#export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
#export NNN_FCOLORS=0B0405020006060009060B01 # purple
#export NNN_COLORS='2555'
#export NNN_COLORS=5632
export NNN_IDLE_TIMEOUT=900
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
[[ $(uname) == "Darwin" ]] || export NNN_TRASH=2 # use trash-cli [1] and gio trash [2] instead of deleting

bindkey -s '^a' '^ubc -lq\n'

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey -s '^a' 'bc -lq\n'

bindkey -s '^p' 'nvim -c "lua Snacks.picker.projects()"\n'

bindkey '^[[P' delete-char

#bindkey '^T' transpose-chars
bindkey '^X' fzf-file-widget

bindkey -s '^n' 'n\n'

source <(fzf --zsh)
# FZF stuff
export FZF_DEFAULT_COMMAND='fd --hidden --strip-cwd-prefix --exclude .git'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
FZF_DEFAULT_OPTS="--bind=ctrl-j:down,ctrl-k:up"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
export FZF_CTRL_C_OPTS="--preview 'lsd --tree --color=always {} | head -200'"
export FZF_CTRL_R_OPTS="
   --preview 'echo {}' --preview-window up:3:hidden:wrap
   --bind 'ctrl-/:toggle-preview'
   --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
   --color header:italic
    --header 'Press CTRL-Y to copy command into clipboard'"
# export FZF_TMUX_OPTS=" -p90%,70%"

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

export STARSHIP_CONFIG=~/.config/zsh/starship.toml
eval "$(starship init zsh)"

# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'

# Load syntax highlighting; should be last.
# source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
