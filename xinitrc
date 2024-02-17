numlockx
eval "$(ssh-agent)"
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
if [ -d "$HOME/.cargo/bin" ] ; then 
  export PATH="$PATH:$HOME/.cargo/bin"
fi
if [ -d "$HOME/.local/bin" ] ; then 
  export PATH="$PATH:$HOME/.local/bin"
fi
exec i3
