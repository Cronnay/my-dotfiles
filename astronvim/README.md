# AstroNvim

Stow-compatible package for installing AstroNvim as the active Neovim default.

## Install

From the repository root:

```sh
stow -t ~ astronvim
```

This links `astronvim/.config/nvim` to `~/.config/nvim`, so plain `nvim` loads AstroNvim.

The first launch will bootstrap Lazy and install plugins:

```sh
nvim
```

## Notes

- `nvim/` and `lvim/` are historical editor configs and should be left intact.
- This environment starts as a minimal editor baseline. Language-specific tooling can be added after the base setup is working.
