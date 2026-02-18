source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# User-local binaries
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/bin:$PATH"

# Better navigation and prompt
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
