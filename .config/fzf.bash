# Setup fzf
# ---------
if [[ ! "$PATH" == */home/ser/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/ser/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/ser/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/ser/.fzf/shell/key-bindings.bash"
