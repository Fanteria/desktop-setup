#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
bash /usr/share/powerline/bindings/shell/powerline.sh

function _update_ps1() {
    PS1="$(powerline shell left)\n └── "
    #PS1="$(powerline shell left) $(parse_git_branch)\n └── "
}

if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

alias ls='ls --color=auto'
alias icat='kitty +kitten icat'
alias pingg='ping 8.8.8.8'
alias school='cd /home/jirka/Projects/school/master/'
alias offLaptopDisplay='xrandr --output eDP-1 --off'


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
