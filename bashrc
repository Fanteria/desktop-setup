#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
bash /usr/share/powerline/bindings/shell/powerline.sh

export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
export TERM=xterm

# (cat ~/.cache/wal/sequences &)

function _update_ps1() {
    PS1="$(powerline shell left)\n └── "
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

alias ls='ls --color=auto'
alias icat='kitty +kitten icat'
alias pingg='ping 8.8.8.8'
alias school='cd /home/jirka/Projects/school/master/'
alias backlight='sudo xbacklight -set '
alias mountu='sudo mount -o uid=jirka,gid=users,fmask=113,dmask=002'
alias gdisksync='rclone sync /home/jirka/Music gdisc:/Music && rclone sync /home/jirka/Documents gdisc:/Documents && rclone sync /home/jirka/Pictures/Pictures/DreamShitpost gdisc:/Pictures/Pictures/DreamShitpost && rclone sync /home/jirka/Pictures/Pictures/Wallpapers/ gdisc:/Pictures/Pictures/Wallpaper'
alias tkitty='kitty --config ~/.config/kitty/transparent.conf'
alias setEnv='export $(grep -v "^#" .env | xargs -d "\n")'
alias unsetEnv='unset $(grep -v "^#" .env | sed -E "s/(.*)=.*/\1/" | xargs -d "\n")'
alias markdown2latex='python ~/Projects/markdown-to-latex/main.py'
alias gcalt='python ~/Projects/gcaltasks/gcaltasks/main.py'
alias cc='clear && cargo check'
alias cr='cargo run'
alias ct='cargo test'

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
