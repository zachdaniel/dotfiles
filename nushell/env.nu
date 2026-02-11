# XDG
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")

# Homebrew
let brew_prefix = "/opt/homebrew"
$env.HOMEBREW_PREFIX = $brew_prefix
$env.HOMEBREW_CELLAR = ($brew_prefix | path join "Cellar")
$env.HOMEBREW_REPOSITORY = $brew_prefix

# Erlang options
$env.KERL_BUILD_DOCS = "yes"
$env.KERL_CONFIGURE_OPTIONS = $"--with-ssl=($brew_prefix)/opt/openssl"
$env.ERL_AFLAGS = "-kernel shell_history enabled"

# PYENV
$env.PYENV_ROOT = ($env.HOME | path join ".pyenv")

# Java
$env.JAVA_HOME = "/usr/libexec/java_home"

# Editors
$env.EDITOR = "nvim"
$env.ELIXIR_EDITOR = "nvim +[line_number] [filename]"
$env.VISUAL = $env.EDITOR

# Elixir
$env.MIX_OS_DEPS_COMPILE_PARTITION_COUNT = ((sys cpu | length) / 2 | into string)

# Build flags
$env.LDFLAGS = $"-L($brew_prefix)/opt/icu4c@76/lib"
$env.CPPFLAGS = $"-I($brew_prefix)/opt/icu4c@76/include"
$env.PKG_CONFIG_PATH = $"($brew_prefix)/opt/icu4c@76/lib/pkgconfig"

# Bun
$env.BUN_INSTALL = ($env.HOME | path join ".bun")

# PATH
$env.PATH = (
    $env.PATH
    | prepend $"($brew_prefix)/sbin"
    | prepend $"($brew_prefix)/bin"
    | prepend $"($env.HOME)/.cargo/bin"
    | prepend $"($env.HOME)/.local/share/bob/nvim-bin"
    | prepend $"($brew_prefix)/opt/postgresql@17/bin"
    | prepend $"($brew_prefix)/opt/qt@5/bin"
    | prepend $"($env.HOME)/scripts"
    | prepend $"($brew_prefix)/opt/icu4c@76/bin"
    | prepend $"($brew_prefix)/opt/icu4c@76/sbin"
    | prepend $"($env.HOME)/.local/bin"
    | prepend $"($env.HOME)/.bun/bin"
    | prepend $"($env.HOME)/.sst/bin"
    | uniq
)

# Source API keys from ~/.envrc
if ($env.HOME | path join ".envrc" | path exists) {
    open ($env.HOME | path join ".envrc")
    | lines
    | where {|line| ($line | str trim) starts-with "export " }
    | each {|line|
        let kv = ($line | str replace "export " "" | split column "=" name value | first)
        {($kv.name): $kv.value}
    }
    | reduce {|it, acc| $acc | merge $it}
    | load-env
}

# Generate starship.nu for config.nu to source
if ("/opt/homebrew/bin/starship" | path exists) {
    ^/opt/homebrew/bin/starship init nu | save -f ($nu.default-config-dir | path join "starship.nu")
}

# Generate mise.nu for config.nu to source
if ($"($brew_prefix)/bin/mise" | path exists) {
    ^($"($brew_prefix)/bin/mise") activate nu | save -f ($nu.default-config-dir | path join "mise.nu")
}
