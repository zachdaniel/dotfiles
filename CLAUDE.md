# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository that manages configuration files for a macOS development environment using dotbot. The setup includes configurations for:
- Neovim (with extensive plugin configuration)
- Kitty terminal
- Zsh shell (with Oh My Zsh)
- Git (including lazygit)
- Yazi file manager
- Various development tools

## Common Commands

### Initial Setup
```bash
./install  # Run from repository root to install all dotfiles and configurations
~/scripts/setup-dotfiles  # Alternative setup script
```

### Package Management
```bash
cd ~/.dotfiles && brew bundle  # Install/update Homebrew packages from Brewfile
~/.dotfiles/priv_scripts/cargo-install  # Install Rust packages from CargoFile
```

### Repository Management
The repository uses dotbot for managing symlinks. The main configuration is in `install.conf.yaml` which:
1. Updates git submodules
2. Runs cargo install script
3. Creates symlinks for all configuration files
4. Runs brew bundle to install dependencies

## Architecture

### Configuration Files Structure
- `install.conf.yaml`: Main dotbot configuration defining symlinks and installation steps
- `Brewfile`: macOS package dependencies (via Homebrew)
- `CargoFile`: Rust package dependencies
- `mcpservers.json`: MCP (Model Context Protocol) server configurations

### Major Component Directories
- `nvim/`: Neovim configuration using lazy.nvim plugin manager
- `kitty/`: Kitty terminal configuration
- `zsh/`: Zsh shell configuration files (.zshrc, .zshenv, .zprofile)
- `git/`: Git configuration and lazygit settings
- `yazi/`: Yazi file manager with custom plugins
- `scripts/`: User scripts (publicly accessible)
- `priv_scripts/`: Private utility scripts (cargo-install, project management)

### Neovim Plugin Architecture
The Neovim setup uses lazy.nvim for plugin management with configurations in `nvim/lua/plugins/`. Key plugins include:
- LSP configurations
- AI assistants (Claude Code)
- Git integration (Neogit, Gitsigns)
- File navigation (Telescope, Yazi integration)
- Code completion and snippets (Blink)

### Symlink Mappings
Key configuration files are symlinked from the repository to their expected locations:
- `~/.config/nvim` → `nvim`
- `~/.config/kitty` → `kitty`
- `~/.zshrc` → `zsh/.zshrc`
- `~/.gitconfig` → `git/gitconfig`
- `~/mcpservers.json` → `mcpservers.json`