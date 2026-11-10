
# ==========================================
# ~/.bashrc
# Optimized WSL Bash Configuration
# ==========================================

# Only run for interactive shells
case $- in
    *i*) ;;
    *) return ;;
esac


# ==========================================
# 1. History Configuration
# ==========================================

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize


# ==========================================
# 2. Lesspipe Configuration
# ==========================================

if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh /usr/bin/lesspipe)"
fi


# ==========================================
# 3. Debian Chroot Configuration
# ==========================================

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# ==========================================
# 4. Terminal Prompt
# Classic Ubuntu Style
# ==========================================

case "$TERM" in
    xterm-color|*-256color)
        color_prompt=yes
        ;;
esac

# Uncomment to force colored prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt force_color_prompt


# ==========================================
# 5. Terminal Window Title
# ==========================================

case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
esac


# ==========================================
# 6. LS_COLORS
# Foreground Colors Only - No Background
# ==========================================

export LS_COLORS='
di=01;34:
ln=01;36:
pi=33:
so=01;35:
do=01;35:
bd=01;33:
cd=01;33:
or=01;31:
mi=00:
fi=00:
ex=01;32:
su=01;31:
sg=01;33:
ca=01;36:
tw=01;34:
ow=01;34:
st=01;34:
*.sh=38;5;222:
*.bash=38;5;222:
*.bat=38;5;172:
*.cmd=38;5;172:
*.vimrc=38;5;13:
*.viminfo=38;5;13:
*.vim=38;5;13:
*.gitconfig=38;5;13:
*.gitignore=38;5;13:
*.gitattributes=38;5;13:
*.bashrc=38;5;13:
*.bash_profile=38;5;13:
*.bash_history=38;5;13:
*.py=38;5;203:
*.pyc=38;5;203:
*.csv=38;5;156:
*.tsv=38;5;156:
*.ipynb=38;5;184:
*.dart=38;5;51:
*.lua=38;5;81:
*.c=38;5;81:
*.h=38;5;81:
*.cpp=38;5;81:
*.hpp=38;5;81:
*.cs=38;5;46:
*.go=38;5;81:
*.php=38;5;81:
*.css=38;5;41:
*.html=38;5;178:
*.java=38;5;74:
*.js=38;5;74:
*.jsx=38;5;74:
*.ts=38;5;115:
*.tsx=38;5;115:
*.json=38;5;178:
*.xml=38;5;178:
*.yaml=38;5;178:
*.yml=38;5;178:
*.toml=38;5;178:
*.ini=38;5;178:
*.conf=38;5;178:
*.cfg=38;5;178:
*.txt=38;5;253:
*.md=38;5;184:
*.log=38;5;248:
*.pdf=38;5;160:
*.zip=38;5;172:
*.rar=38;5;172:
*.7z=38;5;172:
*.tar=38;5;172:
*.gz=38;5;172:
*.bz2=38;5;172:
*.xz=38;5;172:
*.jpg=38;5;140:
*.jpeg=38;5;140:
*.png=38;5;140:
*.gif=38;5;140:
*.mp3=38;5;135:
*.wav=38;5;135:
*.mp4=38;5;135:
'

# Remove newlines and spaces from LS_COLORS
LS_COLORS="${LS_COLORS//$'\n'/}"
LS_COLORS="${LS_COLORS// /}"
export LS_COLORS

# Enable colored output
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# ==========================================
# 7. GCC Colors
# ==========================================

export GCC_COLORS='error=31:warning=35:note=36:caret=32:locus=01:quote=01'


# ==========================================
# 8. Custom Aliases
# ==========================================

# Clear terminal
alias cls='clear'

# Navigation
alias cd..='cd ..'

# Search
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Utilities
alias mkdir='mkdir -p'
alias h='history'
alias j='jobs -l'
alias df='df -h'

# Editor
alias vi='nvim'


# ==========================================
# 9. Alert Alias
# ==========================================

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history | tail -n1 | sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# ==========================================
# 10. Custom Bash Aliases
# ==========================================

if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi


# ==========================================
# 11. Bash Completion
# ==========================================

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


# ==========================================
# 12. Homebrew
# ==========================================

if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi


# ==========================================
# 13. PATH Management
# Prevent Duplicate PATH Entries
# ==========================================

path_prepend() {
    local dir="$1"

    [ -d "$dir" ] || return 0

    case ":$PATH:" in
        *":$dir:"*) ;;
        *)
            PATH="$dir${PATH:+:$PATH}"
            ;;
    esac
}

path_append() {
    local dir="$1"

    [ -d "$dir" ] || return 0

    case ":$PATH:" in
        *":$dir:"*) ;;
        *)
            PATH="${PATH:+$PATH:}$dir"
            ;;
    esac
}


# ==========================================
# 14. Node.js v24.21.0
# ==========================================

path_prepend "$HOME/.local/node-v24.21.0/bin"


# ==========================================
# 15. Cargo / Rust
# ==========================================

if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi


# ==========================================
# 16. Zig 0.16.0
# ==========================================

export ZIG_LOCAL_CACHE_DIR="${ZIG_LOCAL_CACHE_DIR:-$HOME/.cache/zig-local}"

path_prepend "$HOME/.local/opt/zig-0.16.0"


# ==========================================
# 17. Go
# ==========================================

path_append "${GOPATH:-$HOME/go}/bin"

export PATH
