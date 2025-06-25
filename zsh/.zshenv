# Set paths for tools
export XDG_CONFIG_HOME="$HOME/.config"
eval "$(/opt/homebrew/bin/brew shellenv)"

. "$HOME/.cargo/env"
export PYENV_ROOT="$HOME/.pyenv"

## Set erlang options
export KERL_BUILD_DOCS=yes
export KERL_CONFIGURE_OPTIONS="--with-ssl=$(brew --prefix openssl)"
export ERL_AFLAGS="-kernel shell_history enabled"

## Set paths
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="/opt/homebrew/opt/qt@5/bin:$PATH"
# export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/scripts/:$PATH"

# set homebrew prefix
export HOMEBREW_PREFIX=/opt/homebrew

# Java env
export JAVA_HOME=/usr/libexec/java_home

## Set editors

# A cool editor for local and remote sessions
export EDITOR='nvim'
export ELIXIR_EDITOR="nvim +__LINE__ __FILE__"

export VISUAL=$EDITOR

export MIX_OS_DEPS_COMPILE_PARTITION_COUNT=4

export LDFLAGS="-L/opt/homebrew/opt/icu4c@76/lib"
export CPPFLAGS="-I/opt/homebrew/opt/icu4c@76/include"

if [[ -o interactive ]] then
  eval "$(/opt/homebrew/bin/mise activate zsh)"
else
  eval "$(/opt/homebrew/bin/mise activate zsh --shims)"
fi

export LDFLAGS="${LDFLAGS} -L/opt/homebrew/opt/icu4c@76/lib"
export CPPFLAGS="${CPPFLAGS} -I/opt/homebrew/opt/icu4c@76/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c@76/lib/pkgconfig":"$PKG_CONFIG_PATH"
export PATH="/opt/homebrew/opt/icu4c@76/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c@76/sbin:$PATH"

# uv
export PATH="/Users/zachdaniel/.local/bin:$PATH"
