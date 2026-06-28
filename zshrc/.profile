
export KEYTIMEOUT=0.5 # ZSH VI Mode

path_prepend() {
  if [ -d "$1" ] && case ":$PATH:" in *":$1:"*) false;; *) true;; esac; then
    PATH="$1:$PATH"
  fi
}

path_append() {
  if [ -d "$1" ] && case ":$PATH:" in *":$1:"*) false;; *) true;; esac; then
    PATH="$PATH:$1"
  fi
}

# Homebrew on Apple Silicon installs CLIs such as lazygit here.
path_prepend "/opt/homebrew/bin"
path_prepend "/opt/homebrew/sbin"
path_prepend "/usr/local/bin"

# set PATH so it includes user's private bin if it exists
path_prepend "$HOME/bin"

# set PATH so it includes user's private bin if it exists
path_prepend "$HOME/.local/bin"

if [ -f "$HOME/.aliases" ] ; then
  source $HOME/.aliases
fi

if [ -f "$HOME/.aliases.local" ] ; then
  source $HOME/.aliases.local
fi

path_append "/usr/local/go/bin"

# set PATH so it includes user's private go if it exists
if [ -d "$HOME/go" ] ; then
  GOPATH="$HOME/go"
  path_append "$GOPATH/bin"
fi

# RUST
if [ -f "$HOME/.cargo/env" ] ; then
  . "$HOME/.cargo/env"
fi
