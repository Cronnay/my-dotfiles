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

## .NET development

[easy-dotnet.nvim](https://github.com/GustavEikaas/easy-dotnet.nvim) provides
Roslyn language support, debugging, and a test runner. It uses the existing
Snacks picker and nvim-dap integration.

Install a .NET SDK and the companion server, with `dotnet` on your `PATH`:

```sh
dotnet tool install --global EasyDotnet
```

Restart Neovim and let Lazy install the plugin. Open Neovim in your solution
directory, then use `:Dotnet` to browse commands. Use `:Dotnet _server update`
to update the companion server when prompted.

Press `Space D` for the .NET menu:

| Key | Action |
| --- | --- |
| `Space D b` | Build a project and show errors in quickfix |
| `Space D r` | Run a project with a launch profile |
| `Space D d` | Debug a project with a launch profile |
| `Space D T` | Toggle the test runner |
| `Space D R` | Restore the solution |
| `Space D s` | Edit user secrets |
| `Space D a` | Add a NuGet package |
| `Space D c` | Browse all .NET commands |

In test buffers, `Space D t` runs the test under the cursor, `Space D f` runs
the file's tests, and `Space D D` debugs the test under the cursor.
`Space D e` shows build errors and `Space D p` previews a test stack trace.
AstroNvim's `Space d` debugger menu and `Space e` file explorer remain available.

## Notes

- `nvim/` and `lvim/` are historical editor configs and should be left intact.
- Language tooling is configured in `astronvim/.config/nvim/lua/plugins/`.
