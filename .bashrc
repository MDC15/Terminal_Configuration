#!/bin/bash

# This script is used to configure the terminal 
# for the Git Bash shell on Windows.

# Configure oh-my-posh theme
configure_oh_my_posh() {
    eval "$(oh-my-posh init bash --config ~/AppData/Local/Programs/oh-my-posh/themes/dracula.omp.json)"
}

# Configure LS_COLORS
configure_ls_colors() {
    local color_configs=(
        "di=38;5;255"  # Directory: White
        "*.sh=38;5;222" "*.bat=38;5;172"
        "*.vimrc=38;5;13" "*.viminfo=38;5;13" "*.vim=38;5;13"
        "*.gitconfig=38;5;13" "*.bashrc=38;5;13" "*.bash_profile=38;5;13" "*.bash_history=38;5;13"
        "*.py=38;5;203" "*.csv=38;5;156" "*.ipynb=38;5;184" "*.dart=38;5;51"
        "*.lua=38;5;81" "*.cpp=38;5;81" "*.cs=38;5;46" "*.go=38;5;81"
        "*.php=38;5;81" "*.css=38;5;41" "*.html=38;5;178" "*.java=38;5;74"
        "*.js=38;5;74" "*.ts=38;5;115" "*.json=38;5;178" "*.xml=38;5;178"
        "*.yaml=38;5;178" "*.yml=38;5;178"
        "*.txt=38;5;253" "*.md=38;5;184"
    )

    for config in "${color_configs[@]}"; do
        LS_COLORS=$LS_COLORS":$config"
    done

    export LS_COLORS
    export GCC_COLORS='error=31:warning=35:note=36:caret=32:locus=01:quote=01'
}

# Set up aliases
set_aliases() {
    alias cls='clear'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias ls='ls --color=auto'
    alias cd..='cd ..'
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias mkdir='mkdir -pv'
    alias h='history'
    alias j='jobs -l'
    alias df='df -h'
    alias vi='nvim'
    alias ls='ls_with_icons'
}


# Convert size to human-readable format
human_readable_size() {
    local size=$1
    local div=1
    local unit='Byte'

    if ((size >= 1073741824)); then
        div=1073741824
        unit='GB'
    elif ((size >= 1048576)); then
        div=1048576
        unit='MB'
    elif ((size >= 1024)); then
        div=1024
        unit='KB'
    fi

    local result=$(( (size * 100 + div / 2) / div ))
    printf "%d.%02d %s" $((result / 100)) $((result % 100)) "$unit"
}

# Display icons and details for folders and files
ls_with_icons() {
    local file_icons=(

        # Programming and script languages
        "sh:📜:222" "bash:📜:222" "zsh:📜:222"
        "py:🐍:203" "pyc:🐍:203" "pyo:🐍:203" "pyd:🐍:203"
        "js:✨:74" "ts:🔷:115" "jsx:⚛️:74" "tsx:🔷⚛️:115"
        "cs:🕹️:46" "csx:💻:46"
        "java:☕:74" "class:☕:74" "jar:☕:74"
        "c:⚙️:81" "cpp:⚙️:81" "h:⚙️:81" "hpp:⚙️:81"
        "go:🐹:81"

         # File cấu hình và hệ thống
        "json:⚙️:178" "yaml:⚙️:178" "yml:⚙️:178"
        "toml:⚙️:178" "ini:⚙️:178" "conf:⚙️:178"
        "cfg:⚙️:178" "rc:⚙️:178"
        "gitignore:🙈:240" "gitattributes:🙉:240"

        # File dữ liệu
        "csv:📊:156" "tsv:📊:156"
        "sqlite:🗃️:25" "db:🗃️:25"
        
        # Markup and styling languages
        "html:🌐:178" "css:🎨:42" "xml:📰:178"
        "md:📝:184" 
        
        # Office documents
        "doc:📘:27" "xls:📗:28" "ppt:📙:166" "pdf:📕:160"
        
        # Media files
        "jpg:🖼️:140" "png:🖼️:140" "gif:🖼️:140" 
        "mp3:🎵:135" "wav:🎵:135" "mp4:🎬:135"
        
        # Archives
        "zip:📦:172" "rar:📦:172" "7z:📦:172" "tar:📦:172"
        "gz:📦:172" "bz2:📦:172" "xz:📦:172"
        
        # Executables
        "exe:⚡:40" "msi:⚡:40" "bat:⚡:40" "cmd:⚡:40"
        "app:⚡:40" "dmg:⚡:40"
        
        # Miscellaneous
        "txt:📝:253"
        "log:📜:248"

    )

    printf "%-12s %-12s %-10s %-22s %s\n" "Permissions" "Size" "User" "Modified" "Name"
    printf "%s\n" "============|=============|==========|======================|===================="

    for item in *; do
        local stat_info=$(stat -c "%A %s %U %y" "$item")
        read -r perms size user modified <<< "$stat_info"
        
        modified=$(date -d "$modified" "+%Y-%m-%d %H:%M")
        
        if [ -d "$item" ]; then
            printf "%-12s %-12s %-10s %-22s \033[1;255m📁 %s\033[0m\n" "$perms" "-" "$user" "$modified" "$item"
        elif [ -f "$item" ]; then
            readable_size=$(human_readable_size $size)
            ext="${item##*.}"
            icon="📄"
            color="37"
            for file_icon in "${file_icons[@]}"; do
                IFS=':' read -r ext_match icon_match color_match <<< "$file_icon"
                if [ "$ext" = "$ext_match" ]; then
                    icon="$icon_match"
                    color="$color_match"
                    break
                fi
            done
            printf "%-12s %-12s %-10s %-22s \033[1;${color}m%s %s\033[0m\n" "$perms" "$readable_size" "$user" "$modified" "$icon" "$item"
        fi
    done
}

# Main function to run all configurations
main() {
    configure_oh_my_posh
    configure_ls_colors
    set_aliases
    bind 'set bell-style none'
}

# Run the main function
main
