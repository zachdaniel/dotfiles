source $"($nu.cache-dir)/carapace.nu"

# Buffer editor for Ctrl+X Ctrl+E
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

# Auto-launch tmux if not already in tmux and not in zed/warp
if ($env.TMUX? | is-empty) and ($env.GUI? | default "" | $in not-in ["zed", "warp"]) {
    ^tmux
}

# Starship prompt
source starship.nu

# Mise
source mise.nu

# Direnv hook
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
    if (which direnv | is-empty) { return }

    direnv export json | from json | default {} | load-env
    if ($env.PATH | describe) == "string" {
        $env.PATH = ($env.PATH | split row (char esep))
    }
}]
