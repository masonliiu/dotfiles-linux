# Common aliases with graceful fallbacks
if type -q eza
    alias ls='eza --group-directories-first --icons=auto'
    alias ll='eza -lah --group-directories-first --icons=auto'
    alias la='eza -a --group-directories-first --icons=auto'
else
    alias ls='ls --color=auto'
    alias ll='ls -lah'
    alias la='ls -A'
end

if type -q bat
    alias cat='bat --style=plain --paging=never'
end

if type -q fd
    alias find='fd'
end

alias g='git'
alias k='kubectl'
alias d='docker'
