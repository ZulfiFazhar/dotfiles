function fish_greeting
    set -l cur_shell "caelestia"
    test -f ~/.local/state/current_shell && set cur_shell (cat ~/.local/state/current_shell 2>/dev/null)

    switch $cur_shell
        case noctalia
            set_color -o magenta
            echo '     _   _            _        _ _       '
            echo '    / | / /___   ____/ /____ _/ (_)__ _  '
            echo '   /  |/ / _ \/ ___/ __/ _ `/ / / _ `/   '
            echo '  /_/|__/\___/\___/\__/\_,_/_/_/\_,_/    '
            set_color normal
        case serpantinum
            set_color -o green
            echo '     ____                               _   _                     '
            echo '    / ___/ ___  _________  ____ _____  / /_(_)___  __  ______ ___ '
            echo '    \__ \ / _ \/ ___/ __ \/ __ `/ __ \/ __/ / __ \/ / / / __ `__ \\'
            echo '   ___/ //  __/ /  / /_/ / /_/ / / / / /_/ / / / / /_/ / / / / / /'
            echo '  /____/ \___/_/  / .___/\__,_/_/ /_/\__/_/_/ /_/\__,_/_/ /_/ /_/ '
            echo '                 /_/                                              '
            set_color normal
        case '*'
            echo -ne '\x1b[38;5;16m'
            echo '     ______           __          __  _       '
            echo '    / ____/___ ____  / /__  _____/ /_(_)___ _ '
            echo '   / /   / __ `/ _ \/ / _ \/ ___/ __/ / __ `/ '
            echo '  / /___/ /_/ /  __/ /  __(__  ) /_/ / /_/ /  '
            echo '  \____/\__,_/\___/_/\___/____/\__/_/\__,_/   '
            set_color normal
    end

    command -v fastfetch &> /dev/null && fastfetch --key-padding-left 5
end
