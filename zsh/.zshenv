## Set paths for tools
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
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/scripts/:$PATH"

# set homebrew prefix
export HOMEBREW_PREFIX=/opt/homebrew

## Set editors
export ELIXIR_EDITOR="zed __FILE__:__LINE__"
export EDITOR="zed -n -w"
export VISUAL="zed -n -w"
