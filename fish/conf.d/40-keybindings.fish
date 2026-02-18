if status is-interactive
    fish_vi_key_bindings

    # Keep autosuggestions visible but subtle.
    set -g fish_color_autosuggestion 5c6370

    # Ctrl+f opens file search quickly.
    bind -M insert \cf 'commandline -i (fzf)'

    # Alt+l accepts autosuggestion.
    bind -M insert \el accept-autosuggestion

    # Ctrl+e accepts one word from autosuggestion.
    bind -M insert \ce forward-word
end
