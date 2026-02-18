#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# User-local binaries
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/bin:$PATH"

# Quality of life aliases
alias ll='ls -lah'
alias la='ls -A'

# Better navigation and prompt
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi
