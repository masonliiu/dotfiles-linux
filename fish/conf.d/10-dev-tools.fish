# User-local bins
fish_add_path -m $HOME/.local/bin $HOME/go/bin $HOME/bin

# Fast directory jumping
if type -q zoxide
    zoxide init fish | source
end

# Prompt
if type -q starship
    starship init fish | source
end
