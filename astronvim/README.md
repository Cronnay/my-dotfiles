# AstroNvim

Stow-compatible package for installing AstroNvim as the active Neovim default.

## Install

Back up any existing `~/.config/nvim` before installing. Also move
`~/.local/share/nvim`, `~/.local/state/nvim`, and `~/.cache/nvim` into the
backup to keep the old plugins and runtime state available for rollback.
See the [official installation guide](https://docs.astronvim.com/) for details.

From the repository root, once `~/.config/nvim` is available:

```sh
stow -t ~ astronvim
```

This links `astronvim/.config/nvim` to `~/.config/nvim`, so plain `nvim` loads AstroNvim.

If GNU Stow is not installed, use a direct symlink from the repository root:

```sh
ln -s "$PWD/astronvim/.config/nvim" "$HOME/.config/nvim"
```

The first launch will bootstrap Lazy and install plugins:

```sh
nvim
```

## Local backup and rollback

The previous active config and repository config were backed up in
`backups/nvim-20260912-092525/`. This machine-local directory is ignored by Git.
`active-config/` is a verified copy of the previous `~/.config/nvim`, and
`repo-config/` preserves the historical `nvim/` directory.
Activation also moves the original config to `original-config/` and the old
runtime directories to `data/`, `state/`, and `cache/` in the same backup.

To roll back, close Neovim, unlink `~/.config/nvim`, and move `original-config/`
back to `~/.config/nvim`. Move the AstroNvim data, state, and cache directories
aside, then restore `data/`, `state/`, and `cache/` to their original paths
listed above.

## Notes

- `nvim/` and `lvim/` are historical editor configs and should be left intact.
- This environment starts as a minimal editor baseline. Language-specific tooling can be added after the base setup is working.
