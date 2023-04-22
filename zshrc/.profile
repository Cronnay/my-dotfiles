
export KEYTIMEOUT=0.5 # ZSH VI Mode
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi

if [ -f "$HOME/.aliases" ] ; then
  source $HOME/.aliases
fi

if [ -f "$HOME/.aliases.local" ] ; then
  source $HOME/.aliases.local
fi

if [ -d "/usr/local/go" ] ; then
  PATH="$PATH:/usr/local/go/bin"
fi

# set PATH so it includes user's private go if it exists
if [ -d "$HOME/go" ] ; then
  GOPATH="$HOME/go"
  PATH="$PATH:$GOPATH/bin"
fi

# RUST
if [ -d "$HOME/.cargo" ] ; then
 PATH="$PATH:$HOME/.cargo/env"
fi
