# Set paths for tools
eval "$(/opt/homebrew/bin/brew shellenv)"
. "$HOME/.cargo/env"
export PYENV_ROOT="$HOME/.pyenv"

## Set erlang options
export KERL_BUILD_DOCS=yes
export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl)"
export ERL_AFLAGS="-kernel shell_history enabled"

## Set paths
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/scripts/:$PATH"

# set homebrew prefix
export HOMEBREW_PREFIX=/opt/homebrew

# Java env
export JAVA_HOME=`/usr/libexec/java_home`

## Set editors

# A cool editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias vim=nvim
  alias vi=nvim
  export ELIXIR_EDITOR="nvim __FILE__:__LINE__"
fi

export DIRENV_LOG_FORMAT=""

export PATH="/opt/homebrew/bin:$PATH"


if [[ -o interactive ]] then
  eval "$(/Users/zachdaniel/.local/bin/mise activate zsh)"
else
  eval "$(/Users/zachdaniel/.local/bin/mise activate zsh --shims)"
fi

