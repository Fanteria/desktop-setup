#
# ~/.bashrc
#

# Add Rust binaries to path
PATH="$PATH:$HOME/.cargo/bin"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ `command -v starship` ] ; then
  eval "$(starship init bash)"
fi

if [ `command -v fzf` ] ; then
  eval "$(fzf --bash)"
fi

# VARIABLES
if [ `command -v nvim` ] ; then
  export EDITOR="/usr/bin/nvim"
  export VISUAL="/usr/bin/nvim"
fi
export HISTCONTROL=ignoreboth
export HISTSIZE=2000
export GOPATH="${HOME}/.go"
if [ `command -v bat` ] ; then
  export BAT_STYLE=plain
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export MANROFFOPT="-c"
fi

# SET LS_COLORS
eval "$(dircolors)"
export LS_COLORS="$LS_COLORS:ow=1;31;102:"

# ALIASES
alias h='history'
alias j='jobs -l'
alias g='git '
alias s='status '
alias a='add '
alias ip='ip --color=auto'
alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias la='ls --color=auto -lha'
alias l.='ls --color=auto -a'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias icat='kitty +kitten icat'
alias pingg='ping 8.8.8.8'
alias mountu='sudo mount -o uid=$USER,gid=users,fmask=113,dmask=002'
alias gdisksync='rclone sync /home/jirka/Music gdisk:/Music && rclone sync /home/jirka/Documents gdisk:/Documents && rclone sync /home/jirka/Pictures/Pictures gdisk:/Pictures/Pictures'
alias setEnv='export $(grep -v "^#" .env | xargs -d "\n")'
alias unsetEnv='unset $(grep -v "^#" .env | sed -E "s/(.*)=.*/\1/" | xargs -d "\n")'
if [ `command -v cargo` ] ; then
  alias cc='clear && cargo check'
  alias cr='cargo run'
  alias ct='cargo test'
  alias ccc='clear && cargo clippy'
fi
alias myIP='curl ifconfig.me && echo ""'
if [ `command -v nvim` ] ; then
  alias view='nvim -R'
  alias vim='nvim'
  if [ `command -v fzf` ] ; then
    alias nfzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}" --print0 | xargs -0 -o nvim'
  fi
fi
if [ `command -v fzf` ] ; then
  alias pfzf='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
fi

# FUNCTIONS
testColors() {
MODULUS="${1:-16}"
if ! [[ "$MODULUS" =~ ^[0-9]+$ ]] ; then
    echo "Parameter must be a number."
    return 1
fi
for CODE in {000..255} ; do
  echo -en "\e[30;48;5;${CODE}m ${CODE} "
  if [ `expr 16 - 1` -eq `expr ${CODE} % 16` ] ; then
    echo ""
  fi
done
echo -en "\e[0m"
}

testFonts() {
  echo -e "none: Žluťoučký kůň pěl šílené dábelské ódy."
  echo -e "\e[1mbold: Žluťoučký kůň pěl šílené dábelské ódy.\e[0m"
  echo -e "\e[3mitalic: Žluťoučký kůň pěl šílené dábelské ódy.\e[0m"
  echo -e "\e[3m\e[1mbold italic: Žluťoučký kůň pěl šílené dábelské ódy.\e[0m"
  echo -e "\e[4munderline: Žluťoučký kůň pěl šílené dábelské ódy.\e[0m"
  echo -e "\e[9mstrikethrough: Žluťoučký kůň pěl šílené dábelské ódy.\e[0m"
  echo -e "\e[31mcolored: Žluťoučký kůň pěl šílené dábelské ódy.\e[0m"
  echo -e "special characters: @ # & + $ % ^ * ( ) [ ] { }"
  echo -e "lignatures: ft fi fj -> :: </tag> || &&"
}

git() {
  case "$1" in
    "squash")
      if [ "$#" -ne 2 ] ; then
        echo "Set number of local commits to squash."
        return
      fi
      command git reset --soft "HEAD~$2" && git commit --edit -m"$(git log --format=%B --reverse HEAD..HEAD@{1})"
      ;;
    "cm")
      command git commit -m "${@:2}" ;;
    "all")
      if [ "$#" -gt 3 ] ; then
        echo "Too many arguments."
        return
      fi
      DEPTH="2"
      FIND_PATH="."
      for ARG in "${@:2}" ; do
        if [[ "$ARG" == "-"* ]] ; then
          DEPTH="${ARG:1}"
        else
          FIND_PATH="$ARG"
        fi
      done
      DEPTH=$(("$DEPTH" + 1))
      WORKDIR="$PWD"
      for REPOSITORY in `find "$FIND_PATH" -maxdepth "$DEPTH" -mindepth 1 -type d -name ".git"` ; do
        DIRNAME="$(dirname $REPOSITORY)"
        echo "$DIRNAME"
        cd "$DIRNAME"
        command git status -s
        cd "$WORKDIR"
      done
      ;;
    *)
      command git "$@" ;;
  esac
}

function f {
  find . -name "*${1}*" | tee >(xsel -ib)
}

function fname {
  find . -name "${1}*" | tee >(xsel -ib)
}

function fe {
  find . -name "${1}" | tee >(xsel -ib)
}

function bhelp {
  local output
  local ret_code

  output=$("$@" -h 2> /dev/null)
  if [ $? -ne 0 ] ; then
    output=$("$@" --help 2> /dev/null)
  fi
  ret_code=$?

  bat -l help <<< "$output"
  return $ret_code
}

# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi
# END_KITTY_SHELL_INTEGRATION

if [ -f "$HOME/.aveco-info/scripts/bashrcAveco.sh" ] ; then
  source $HOME/.aveco-info/scripts/bashrcAveco.sh
fi

