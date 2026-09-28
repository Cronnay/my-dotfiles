#!/usr/bin/env bash

set -Eeuo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)}"
DRY_RUN=false
INSTALL_PACKAGES=true
BACKUP_CREATED=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Install the command-line tools used by these dotfiles, safely back up any
conflicting configuration, and link the zsh/tmux and AstroNvim packages.

Options:
  --dry-run        Show what would change without changing anything
  --skip-packages  Skip Homebrew and package installation
  -h, --help       Show this help

Environment:
  DOTFILES_BACKUP_DIR  Override the directory used for conflict backups
EOF
}

log() {
  printf '[dotfiles] %s\n' "$*"
}

die() {
  printf '[dotfiles] Error: %s\n' "$*" >&2
  exit 1
}

run() {
  if "$DRY_RUN"; then
    printf '[dotfiles] Would run:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

while (($#)); do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      ;;
    --skip-packages)
      INSTALL_PACKAGES=false
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
  shift
done

if [[ "$(uname -s)" != "Darwin" && "$INSTALL_PACKAGES" == true ]]; then
  die "Automatic package installation currently supports macOS only. Install git, stow, tmux, Neovim 0.11+, ripgrep, fd, fzf, lazygit, and tree-sitter, then rerun with --skip-packages."
fi

load_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then
      eval "$("$candidate" shellenv)"
      return
    fi
  done
}

install_homebrew() {
  load_homebrew
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  if "$DRY_RUN"; then
    log "Would install Homebrew from https://brew.sh"
    return
  fi

  log "Homebrew is not installed; starting the official installer"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_homebrew
  command -v brew >/dev/null 2>&1 || die "Homebrew installed but is not available on PATH"
}

install_packages() {
  install_homebrew
  if "$DRY_RUN" && ! command -v brew >/dev/null 2>&1; then
    log "Would install packages from $REPO_ROOT/Brewfile"
    return
  fi

  log "Installing missing Homebrew packages"
  run brew bundle --file "$REPO_ROOT/Brewfile"
}

backup_target() {
  local source_path="$1"
  local target_path="$2"
  local relative_target="${target_path#"$HOME"/}"
  local backup_path="$BACKUP_ROOT/$relative_target"

  if [[ ! -e "$target_path" && ! -L "$target_path" ]]; then
    return
  fi

  if [[ -e "$target_path" && "$target_path" -ef "$source_path" ]]; then
    return
  fi

  log "Backing up $target_path to $backup_path"
  run mkdir -p "$(dirname "$backup_path")"
  run mv "$target_path" "$backup_path"
  BACKUP_CREATED=true
}

prepare_stow_targets() {
  local filename

  for filename in .p10k.zsh .profile .tmux.conf .tmux.conf.local .zshenv .zshrc; do
    backup_target "$REPO_ROOT/zshrc/$filename" "$HOME/$filename"
  done

  backup_target "$REPO_ROOT/astronvim/.config/nvim" "$HOME/.config/nvim"
  run mkdir -p "$HOME/.config"
}

install_zgen() {
  if [[ -d "$HOME/.zgen/.git" ]]; then
    log "zgen is already installed"
    return
  fi

  if [[ -e "$HOME/.zgen" || -L "$HOME/.zgen" ]]; then
    die "$HOME/.zgen exists but is not a zgen Git checkout; move it aside and rerun"
  fi

  log "Installing zgen"
  run git clone --depth 1 https://github.com/tarjoilija/zgen.git "$HOME/.zgen"
}

link_dotfiles() {
  log "Linking zsh, tmux, Powerlevel10k, and AstroNvim configuration"
  run stow --dir "$REPO_ROOT" --target "$HOME" --restow zshrc astronvim
}

initialize_shell_plugins() {
  if "$DRY_RUN"; then
    log "Would initialize zgen plugins with an interactive zsh startup"
    return
  fi

  log "Initializing zsh plugins (first run can take a moment)"
  zsh -ic 'exit 0'
}

verify_installation() {
  if "$DRY_RUN"; then
    return
  fi

  local command_name
  local missing=()
  local nvim_version
  local nvim_major
  local nvim_minor
  for command_name in git stow tmux nvim rg fd fzf lazygit tree-sitter; do
    command -v "$command_name" >/dev/null 2>&1 || missing+=("$command_name")
  done

  ((${#missing[@]} == 0)) || die "Missing commands after installation: ${missing[*]}"

  nvim_version="$(nvim --version | awk 'NR == 1 { sub(/^v/, "", $2); print $2 }')"
  IFS=. read -r nvim_major nvim_minor _ <<<"$nvim_version"
  if ((nvim_major == 0 && nvim_minor < 11)); then
    die "AstroNvim requires Neovim 0.11 or newer; found $nvim_version"
  fi

  [[ "$HOME/.config/nvim" -ef "$REPO_ROOT/astronvim/.config/nvim" ]] || die \
    "$HOME/.config/nvim is not linked to the AstroNvim package"
  [[ "$HOME/.zshrc" -ef "$REPO_ROOT/zshrc/.zshrc" ]] || die \
    "$HOME/.zshrc is not linked to the zshrc package"

  log "Verified links and required commands"
}

main() {
  log "Bootstrapping from $REPO_ROOT"

  if "$INSTALL_PACKAGES"; then
    install_packages
  else
    log "Skipping package installation"
    command -v stow >/dev/null 2>&1 || die "stow is required when using --skip-packages"
    command -v git >/dev/null 2>&1 || die "git is required when using --skip-packages"
  fi

  prepare_stow_targets
  install_zgen
  link_dotfiles
  initialize_shell_plugins
  verify_installation

  if "$BACKUP_CREATED"; then
    if "$DRY_RUN"; then
      log "Would preserve previous configuration in $BACKUP_ROOT"
    else
      log "Previous configuration was preserved in $BACKUP_ROOT"
    fi
  fi
  log "Setup complete. Open a new terminal and select MesloLGS NF in its font settings."
}

main
