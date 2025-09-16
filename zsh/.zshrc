zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
setopt MENU_COMPLETE
setopt no_list_ambiguous
bindkey -e
bindkey '^R' history-incremental-pattern-search-backward

autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Set PLZ_FULL_CMD for the plz command to know about pipelines
preexec() {
  export PLZ_FULL_CMD="$1"
  
  # Rename tmux window to 'nvim' when running nvim
  if [ -n "$TMUX" ] && [[ "$1" =~ ^nvim($|[[:space:]]) ]]; then
    tmux rename-window "nvim"
  fi
}

if [ -n "$TMUX" ] || [ "$GUI" = "zed" ] || [ "$GUI" = "warp" ] ; then
  eval "$(direnv hook zsh)"
  eval "$(starship init zsh)"
elif [ "$GUI" != "zed" ]; then
  tmux
fi

# bun completions
[ -s "/Users/zachdaniel/.bun/_bun" ] && source "/Users/zachdaniel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# tmux CMD+Click
clean_nvim_open_history() {
    # Write current history to file
    fc -W
    
    # Check if last line contains tmux_nvim_open
    if tail -1 ~/.zsh_history | grep -q "tmux_nvim_open "; then
        # Remove last line
        sed -i '' '$d' ~/.zsh_history
        
        # Check for 'q' - zsh history format includes timestamp like ": 1234567890:0;q"
        if tail -1 ~/.zsh_history | grep -qE "(^|;)q$"; then
            # Remove that too
            sed -i '' '$d' ~/.zsh_history
        fi
    fi
    
    # Reload history
    fc -R
}

# Updated tmux_nvim_open function
tmux_nvim_open() {
    clean_nvim_open_history
    local file="$1"
    local line="${2:-1}"
    
    local nvim_window=$(tmux list-windows -F '#{window_index}: #{window_name}' | grep -i 'nvim' | head -1 | cut -d: -f1)
    
    if [ -n "$nvim_window" ]; then
        tmux select-window -t "$nvim_window"
        tmux send-keys -t "${nvim_window}.1" Escape ":e $file" C-m "${line}G"
    else
        tmux new-window "nvim '$file' +$line"
    fi
    clean_nvim_open_history
}
