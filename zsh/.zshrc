zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
setopt MENU_COMPLETE
setopt no_list_ambiguous
bindkey -e
bindkey '^R' history-incremental-pattern-search-backward

autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

if [ -n "$TMUX" ] || [ "$GUI" = "zed" ] || [ "$GUI" = "warp" ] ; then
  eval "$(direnv hook zsh)"
  eval "$(starship init zsh)"
elif [ "$GUI" != "zed" ]; then
  tmux
fi

autoload -Uz compinit
compinit
fpath=(~/.zsh $fpath)
    zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# bun completions
[ -s "/Users/zachdaniel/.bun/_bun" ] && source "/Users/zachdaniel/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

