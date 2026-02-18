if status is-interactive
    set -gx EDITOR nvim
    set -gx VISUAL nvim

    if type -q fd
        set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    end

    set -gx FZF_DEFAULT_OPTS "--height 45% --layout=reverse --border"

    if type -q fzf
        fzf --fish | source
    end

    function mkcd
        mkdir -p "$argv[1]" && cd "$argv[1]"
    end
end
