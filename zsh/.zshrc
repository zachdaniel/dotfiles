zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
setopt MENU_COMPLETE
setopt no_list_ambiguous
bindkey -e
bindkey '^R' history-incremental-pattern-search-backward

autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

# Ghostty split navigation
ghostty-nav-left()  { ghostty-nav left  2>/dev/null }
ghostty-nav-down()  { ghostty-nav down  2>/dev/null }
ghostty-nav-up()    { ghostty-nav up    2>/dev/null }
ghostty-nav-right() { ghostty-nav right 2>/dev/null }
zle -N ghostty-nav-left
zle -N ghostty-nav-down
zle -N ghostty-nav-up
zle -N ghostty-nav-right
bindkey '^h' ghostty-nav-left
bindkey '^j' ghostty-nav-down
bindkey '^k' ghostty-nav-up
bindkey '^l' ghostty-nav-right

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

# aliases

alias ls='ls -A'

# sst
export PATH=/Users/zachdaniel/.sst/bin:$PATH
