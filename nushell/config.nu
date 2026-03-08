source $"($nu.cache-dir)/carapace.nu"

# Buffer editor for Ctrl+X Ctrl+E
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false

# Auto-launch tmux if not already in tmux and not in zed/warp
# Disabled: using ghostty windows for project switching instead
# if ($env.TMUX? | is-empty) and ($env.GUI? | default "" | $in not-in ["zed", "warp"]) {
#     ^tmux
# }

# Starship prompt
source starship.nu

# Mise
source mise.nu

# Ghostty split navigation
$env.config.keybindings = $env.config.keybindings? | default [] | append [
  {
    name: ghostty_split_left
    modifier: control
    keycode: char_h
    mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand, cmd: "ghostty-nav left" }
  }
  {
    name: ghostty_split_down
    modifier: control
    keycode: char_j
    mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand, cmd: "ghostty-nav down" }
  }
  {
    name: ghostty_split_up
    modifier: control
    keycode: char_k
    mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand, cmd: "ghostty-nav up" }
  }
  {
    name: ghostty_split_right
    modifier: control
    keycode: char_l
    mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand, cmd: "ghostty-nav right" }
  }
]

# Direnv hook

$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

$env.config.hooks.env_change.PWD ++= [{||
    if (which direnv | is-empty) { return }

    direnv export json | from json | default {} | load-env
    if ($env.PATH | describe) == "string" {
        $env.PATH = ($env.PATH | split row (char esep))
    }
}]
