# ╔═══════════════════════════════════════════════════════════╗
# ║     C H E R R Y   B L O S S O M   M O N K   S H E L L     ║
# ║          Arch-Dragon — Keeper of Quiet Terminals          ║
# ╚═══════════════════════════════════════════════════════════╝
#
#   The shell is a temple.
#   Commands fall like petals.
#   Precision is peace.
#

# ────────────────────────────────────────────────────────────
# Locale
# ────────────────────────────────────────────────────────────
set -x LANG "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"

# ────────────────────────────────────────────────────────────
# Wayland
# ────────────────────────────────────────────────────────────
set -x QT_QPA_PLATFORM "wayland"
set -x XDG_SESSION_TYPE "wayland"

# ╔═══════════════════════════════════════════════════════════╗
# ║                      A L I A S E S                        ║
# ╚═══════════════════════════════════════════════════════════╝

# Navigation — silent monk steps
alias ..    'cd ..'
alias ...   'cd ../..'
alias ....  'cd ../../..'
alias --    'cd -'
alias ~     'cd ~'

# Listing — parchment clarity
alias ls 'ls --color=auto -h'
alias ll 'ls --color=auto -lh'
alias la 'ls --color=auto -lah'
alias l  'ls --color=auto -CF'

if type -q bat
    alias cat 'bat --style=plain'
end

alias less 'less -R'

# File moves — gentle, deliberate
alias cp    'cp -iv'
alias mv    'mv -iv'
alias rm    'rm -Iv'
alias mkdir 'mkdir -pv'

# Searching the grove
alias grep 'grep --color=auto'
alias rg   'rg --color=auto'
alias ff   'find . -name'

# System scrying
alias df      'df -h'
alias du      'du -h'
alias free    'free -h'
alias ps      'ps aux'
alias top     'htop'
alias uptime  'uptime -p'

# Arch rituals — light incense
alias update  'sudo timeshift --create; and sudo pacman -Syu; and sudo mkinitcpio -P; and echo "🌸 System renewed."'
alias install 'sudo pacman -S'
alias remove  'sudo pacman -Rns'
alias search  'pacman -Ss'
alias orphans 'pacman -Qdtq'

# powerprofilesctl
alias ppd-balance 'sudo powerprofilesctl set balanced; and echo "Silent monk footsteps whisper ☯"'
alias ppd-performance 'sudo powerprofilesctl set performance; and echo "The Dragon roars 🏮🐉⛩️"'
alias ppd-bat-saver 'sudo powerprofilesctl set power-saver; and echo "The dragon rests peacefully ✩₊˚.⋆☾𓃦☽⋆⁺₊✧"'

# ╔═══════════════════════════════════════════════════════════╗
# ║                      F U N C T I O N S                    ║
# ╚═══════════════════════════════════════════════════════════╝

# Clean orphaned packages — return the petals to the earth
function cleanup
    set orphans (pacman -Qdtq 2>/dev/null)

    if test (count $orphans) -gt 0
        echo "🌸 Found stray petals:"
        printf "   %s\n" $orphans
        read -P "   Sweep them away? [y/N]: " confirm

        if test "$confirm" = "y" -o "$confirm" = "Y"
            sudo pacman -Rns $orphans
            echo "🌿 The garden is clean."
        else
            echo "🍂 They remain—for now."
        end
    else
        echo "🌙 No petals out of place."
    end
end

# Reload config — quiet ritual
function reload
    source ~/.config/fish/config.fish
    echo "🌸 Shell realigned."
end

# Terminal title
function fish_title
    echo (whoami)@(hostname): (prompt_pwd)
end

# ╔═══════════════════════════════════════════════════════════╗
# ║               W E L C O M E   M E D I T A T I O N          ║
# ╚═══════════════════════════════════════════════════════════╝

if status is-interactive
    clear

    set_color magenta
    echo "╔═══════════════════════════════════════════════╗"
    set_color brred
    echo "   🐉 Welcome back, Arch-Dragon — Sakura Monk"
    set_color brmagenta
    printf "   Host:   "; echo (hostname)
    printf "   Kernel: "; echo (uname -r)
    printf "   Uptime: "

    if uptime -p >/dev/null 2>&1
        echo (string join ' ' (uptime -p | cut -d ' ' -f2-))
    else
        echo (uptime | sed 's/.*up *//; s/,.*//')
    end

    printf "   Date:   "
    echo (date '+%A, %B %d, %Y %H:%M:%S')

    set_color magenta
    echo "╚═══════════════════════════════════════════════╝"
    set_color normal
    echo
end

# ────────────────────────────────────────────────────────────
# Fastfetch
# ────────────────────────────────────────────────────────────
if type -q fastfetch
    fastfetch --logo "Arch" --color magenta
end

# ╔═══════════════════════════════════════════════════════════╗
# ║                     P R O M P T                           ║
# ╚═══════════════════════════════════════════════════════════╝

function fish_greeting
    echo "The shell is empty. The mind follows. 🀄"
end

function fish_prompt
    set -l last $status

    set -l userc (set_color brred)
    set -l hostc (set_color brmagenta)
    set -l dirc  (set_color white)
    set -l okc   (set_color green)
    set -l errc  (set_color red)
    set -l reset (set_color normal)

    set -l sep " ♢ "

    echo -n "$userc$USER$reset"
    echo -n "$sep$hostc"(hostname)"$reset"
    echo -n "$sep$dirc"(basename (pwd))"$reset"

    if test $last -eq 0
        echo -n " $okc◆$reset "
    else
        echo -n " $errc◇$reset "
    end

    echo -n "🌸 "
end
