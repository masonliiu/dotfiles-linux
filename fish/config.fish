if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end
set -gx PATH "$HOME/.npm-global/bin" $PATH
set -gx EDITOR nvim
set -gx VISUAL nvim

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# opencode (optional)
if test -d "$HOME/.opencode/bin"
    fish_add_path "$HOME/.opencode/bin"
end
