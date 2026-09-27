unsetopt nomatch  # fix for yt-dlp aliases
setopt autocd     # automatically cd into typed directory.
setopt interactive_comments
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_ALL_DUPS # drop older duplicate when a command is re-run
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY          # !! / !$ expand into the line instead of running at once
setopt EXTENDED_HISTORY     # store start time and duration
setopt INC_APPEND_HISTORY   # write each command immediately, not on shell exit
setopt no_flow_control

# History in cache directory
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"
typeset +x HISTFILE  # if exported, child bash writes (and truncates) it

# Drop duplicate PATH entries.
typeset -U path PATH

# Load aliases and shortcuts if existent
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
# Case-insensitive, then partial-word (foo-b<Tab> → foo-bar), then substring match.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*' squeeze-slashes true
# Cache results of slow completers (pacman/yay, kubectl, docker…).
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zmodload zsh/complist

# Full compinit at most once per day; glob qualifier mh+24 avoids forking stat.
zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
zcompdump_stale=(${~zcompdump}(N.mh+24))
if [[ -f "$zcompdump" && ${#zcompdump_stale} -eq 0 ]]; then
    compinit -C -d "$zcompdump"
else
    compinit -d "$zcompdump"
    # compinit rewrites the dump only when fpath changed; keep it ageing.
    touch "$zcompdump" 2>/dev/null
fi
unset zcompdump_stale
# After compinit: it resets _comp_options.
_comp_options+=(globdots) # include hidden files

# Auto-quote URLs (&, ?, ~ etc.) when typed or pasted
autoload -Uz url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Ctrl+Left / Ctrl+Right = move by word (foot sends xterm-style CSI 1;5C/1;5D)
bindkey -M viins '^[[1;5C' vi-forward-word
bindkey -M viins '^[[1;5D' vi-backward-word
bindkey -M vicmd '^[[1;5C' vi-forward-word
bindkey -M vicmd '^[[1;5D' vi-backward-word

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# yazi shell wrapper for changing cwd when exiting
function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
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
# Use beam shape cursor for each new prompt.
autoload -Uz add-zsh-hook
_cursor_beam() { echo -ne '\e[5 q' }
add-zsh-hook preexec _cursor_beam

# foot: mark command output boundaries so pipe-command-output knows what to pipe.
# Disabled: TERMINAL is ghostty, not foot, and this OSC 133 hook was causing
# a stray "%" (zsh's PROMPT_EOL_MARK) to appear before the first prompt.
# autoload -Uz add-zsh-hook
# foot_cmd_start() { echo -ne '\e]133;C\e\\' }
# foot_cmd_end()   { echo -ne '\e]133;D\e\\' }
# add-zsh-hook preexec foot_cmd_start
# add-zsh-hook precmd foot_cmd_end

n () {
    if [ -n "$NNNLVL" ] && [ "${NNNLVL:-0}" -ge 1 ]; then
	      exit
        #return
    fi

    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        command rm -f -- "$NNN_TMPFILE" > /dev/null
    }
}

## TODO: ВОЗМОЖНО ЭТО УЖЕ НЕ НАДО ТАК КАК РАБОТАЕТ НАТИВНО - ПРОВЕРИТЬ
## The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
## If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
## see. To cd on quit only on ^G, remove the "-x" from both lines below,
## without changing the paths.
#if test -n "$XDG_CONFIG_HOME"
#    set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
#elseif
#    set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
#fi

nsel () {
    tr '\0' '\n' < "${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection"
}

export NNN_OPTS='acdAHU'
#export NNN_PLUG='p:mocplay;m:-_mediainfo $nnn;s:_smplayer -minigui $nnn*;a:-_mocp*;y:-_sync*;k:-_fuser -kiv $nnn*;t:-!|tree -ps;e:-_ewrap $nnn*'
export NNN_PLUG='e:-!nvim*;o:finder;f:fzcd;x:fzopen;t:nmount;v:imgview;g:bookmarks;G:cdpath;i:preview-tabbed;w:preview-tui;c:getplugs;z:imgresize;d:diffs;b:boom;q:cdpath;p:imgresize;j:cdpath;h:dups;k:pskill;l:nmount;m:-!mediainfo $nnn;a:rsynccp;u:togglex;n:fzplug;r:!eval $(which lazygit)*;s:-!nvim "$(fd -e md | fzf)"*'
export NNN_PAGER='less -Ri'
#export NNN_PLUG_09='1:a;2:b'
#export NNN_A2F='a:x;b:y'
#export NNN_PLUG={$NNN_PLUG_09}';'{$NNN_PLUG_A2F}';'...
#export NNN_PTERMINAL=kitty
export NNN_OPENER=${XDG_CONFIG_HOME}/nnn/plugins/nuke
#export NNN_BMS='a:/mnt/main/sync/anima;h:~;v:/mnt/main/vid;c:~/.config'
export NNN_FIFO='/tmp/nnn.fifo' # temporary buffer for previews
export NNN_SSHFS="sshfs -o follow_symlinks,reconnect,auto_cache"
export NNN_SEL="$XDG_CONFIG_HOME/nnn/selection"
export SPLIT='v' # to split Kitty vertically
# export NNN_HELP="fastfetch"
export NNN_PREFER_SELECTION=1
export NNN_IDLE_TIMEOUT=900
export NNN_ARCHIVE="\\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$"
# export NNN_FCOLORS="AAAAE631BBBBCCCCDDDD9999"

# use trash-cli [1] and gio trash [2] and macos "trash" instead of deleting
[[ $OSTYPE == linux* ]] && export NNN_TRASH=2 || export NNN_TRASH="trash"

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey -s '^p' 'nvim -c "lua Snacks.picker.projects()"\n'

bindkey '^X' fzf-file-widget
bindkey '^G' fzf-cd-widget

bindkey -s '^n' 'n\n'

eval "$(fzf --zsh)"

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

export STARSHIP_CONFIG="${ZDOTDIR}/starship.toml"
eval "$(starship init zsh)"

# Personal overrides last, so their bindkeys survive `bindkey -v` above.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh-personal" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh-personal"

# Load syntax highlighting; should be last.
# source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
