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
# Sourcing picks up the compiled .zwc automatically when it's newer than the dump.
[[ "$zcompdump.zwc" -nt "$zcompdump" ]] || zcompile "$zcompdump"
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

# Stray "%" on terminal open: PROMPT_SP pads the line to $COLUMNS, and when
# Hyprland resizes the new window mid-way the padding wraps, leaving "%" behind.
# Nothing to protect before the first command, so enable it only after one.
unsetopt prompt_sp
_enable_prompt_sp() { setopt prompt_sp; add-zsh-hook -d preexec _enable_prompt_sp; unfunction _enable_prompt_sp }
add-zsh-hook preexec _enable_prompt_sp

# foot: mark command output boundaries so pipe-command-output knows what to pipe.
# Disabled: TERMINAL is ghostty, not foot, and this OSC 133 hook was causing
# a stray "%" (zsh's PROMPT_EOL_MARK) to appear before the first prompt.
# autoload -Uz add-zsh-hook
# foot_cmd_start() { echo -ne '\e]133;C\e\\' }
# foot_cmd_end()   { echo -ne '\e]133;D\e\\' }
# add-zsh-hook preexec foot_cmd_start
# add-zsh-hook precmd foot_cmd_end


bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

bindkey -s '^p' 'nvim -c "lua Snacks.picker.projects()"\n'

bindkey '^X' fzf-file-widget
bindkey '^G' fzf-cd-widget

# Cache init scripts instead of forking the tool on every start;
# regenerated when the binary is updated. Compiled to .zwc, which
# `source` picks up automatically when it's newer than the script.
_cached_init() {  # <name> <binary> <command...>
    local f="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$1.zsh" bin
    # Look up one command without hashing all of PATH (~3 ms): HASH_LIST_ALL
    # fills the whole table, HASH_DIRS hashes every dir searched up to the hit.
    # Scoped to an anonymous function: localoptions here would also revert
    # options set by the sourced scripts (starship's prompt_subst).
    () { setopt localoptions no_hash_list_all no_hash_dirs; bin=$commands[$1] } $2
    shift 2
    [[ -s "$f" && "$f" -nt "$bin" ]] || "$@" >| "$f"
    [[ "$f.zwc" -nt "$f" ]] || zcompile "$f"
    source "$f"
}

# fzf walker: don't follow symlinks (~/.local/share/bookmarks links into /mnt), skip caches.
# --walker-skip replaces fzf's default list (.git,node_modules), so keep those.
# Per-widget --walker comes after FZF_DEFAULT_OPTS and overrides the widgets' built-in "follow".
_fzf_skip='--walker-skip=.git,node_modules,.cache'
export FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS:-"--walker=file,hidden $_fzf_skip"}     # plain fzf, ^F
export FZF_CTRL_T_OPTS=${FZF_CTRL_T_OPTS:-"--walker=file,dir,hidden $_fzf_skip"}  # ^X
export FZF_ALT_C_OPTS=${FZF_ALT_C_OPTS:-"--walker=dir,hidden $_fzf_skip"}         # ^G
unset _fzf_skip
_cached_init fzf fzf fzf --zsh

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

export STARSHIP_CONFIG="${ZDOTDIR}/starship.toml"
# Bake PROMPT2 into the cache: the stock init forks starship for it on every start.
_starship_init() {
    starship init zsh --print-full-init | sed '/^PROMPT2=/d'
    print -r -- "PROMPT2=${(qq)$(starship prompt --continuation)}"
}
# The baked PROMPT2 depends on the config too.
[[ "$STARSHIP_CONFIG" -nt "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/starship.zsh" ]] &&
    rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/starship.zsh"
_cached_init starship starship _starship_init
unfunction _cached_init _starship_init
# starship.toml has no right_format, so RPROMPT is always empty, yet it
# forks starship on every prompt and vi-mode switch. Drop it if you add one.
RPROMPT=''

# Personal overrides last, so their bindkeys survive `bindkey -v` above.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh-personal" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zsh-personal"

pve-up() {
  wakeonlan 00:e0:4c:ad:f0:da
  until ssh -o ConnectTimeout=2 -o BatchMode=yes -i ~/.ssh/proxmox-server root@192.168.0.105 true 2>/dev/null; do sleep 3; done
  ls /mnt/main >/dev/null && echo "mounted"
}
pve-down() {
  sudo systemctl stop mnt-main.mount
  ssh -i ~/.ssh/proxmox-server root@192.168.0.105 poweroff
}

# Load syntax highlighting; should be last.
# source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
