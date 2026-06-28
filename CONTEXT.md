# Dotfiles

Personal configuration files for command-line tools and editor environments.

## Language

**Parallel editor environment**:
A standalone editor configuration that can be installed and evaluated without replacing existing editor configuration directories.
_Avoid_: Migration, replacement, default config

**AstroNvim environment**:
The editor environment stored in `astronvim/`, intended to become the active Neovim default while preserving existing Neovim and LunarVim directories in the repo.
_Avoid_: Astro config, new nvim

**Active Neovim default**:
The configuration currently installed at `~/.config/nvim` and loaded by plain `nvim`.
_Avoid_: Parallel config, repo folder

**Minimal editor baseline**:
The first AstroNvim environment pass that carries over only essential editor muscle memory and visual preferences, while postponing language-specific tooling.
_Avoid_: Full migration, complete port

**Template-backed environment**:
An editor environment that vendors AstroNvim's official configuration template so it can be installed directly as the active Neovim default.
_Avoid_: Overlay-only config, partial config

**Stow-compatible package**:
A repo directory shaped like the target home directory so it can be symlinked into place with GNU Stow or inspected without custom install scripts.
_Avoid_: Script-only install, manual copy layout

**Historical editor config**:
An existing editor configuration kept for reference or rollback rather than being actively evolved during a new setup.
_Avoid_: Dead config, obsolete config

## Example Dialogue

Dev: "Should AstroNvim replace the current Neovim folder?"
Owner: "Keep `astronvim/` separate in the repo, but install it as the active Neovim default on the machine."
Dev: "Where should the AstroNvim environment live?"
Owner: "Use `astronvim/` so it is clearly separate from `nvim/` and `lvim/`."
Dev: "Should the first AstroNvim pass include Flutter, Java, Swift, DAP, and Copilot?"
Owner: "No, start with a minimal editor baseline and add language tooling after the base environment is proven."
Dev: "Should `astronvim/` contain only local overrides?"
Owner: "No, make it a template-backed environment so the folder is directly installable as the active Neovim default."
Dev: "How should the repo map AstroNvim to `~/.config/nvim`?"
Owner: "Use a Stow-compatible package at `astronvim/.config/nvim/`."
