# Dotfiles

Personal macOS configuration for zsh, Powerlevel10k, tmux, and AstroNvim.

## Fresh-machine setup

Clone the repository and run the installer:

```sh
git clone https://github.com/Cronnay/my-dotfiles.git ~/git/my-dotfiles
cd ~/git/my-dotfiles
./install.sh
```

The installer:

- installs Homebrew if necessary;
- installs the tools in `Brewfile`, including GNU Stow, tmux, Neovim, and a
  Powerlevel10k-compatible Nerd Font;
- installs `zgen` and initializes the configured zsh plugins;
- uses GNU Stow to link `zshrc/` and `astronvim/` into the home directory; and
- moves conflicting configuration into `~/.dotfiles-backup/<timestamp>/`
  before linking anything.

It is safe to rerun after pulling changes. Existing links that already point
into this repository are preserved.

Preview the work without changing the machine:

```sh
./install.sh --dry-run
```

If the required tools are already installed, only configure and link the
dotfiles:

```sh
./install.sh --skip-packages
```

After setup, open a new terminal and select `MesloLGS NF` as the terminal font
so Powerlevel10k and AstroNvim icons render correctly.

## Packages

- `zshrc/` provides `.zshrc`, `.zshenv`, `.profile`, `.p10k.zsh`, and the tmux
  configuration.
- `astronvim/` provides the active `~/.config/nvim` environment.
- `nvim/` and `lvim/` are historical editor configurations and are not linked
  by the installer.
