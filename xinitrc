numlockx
eval "$(ssh-agent)"
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
exec i3

