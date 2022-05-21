#!/bin/bash

if [ "$(whoami)" == "root" ]; then
  echo "Script must be run as a normal user"
  exit
fi

# Directory where the script is
SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"


## Gnome configuration
#sh $SCRIPT_DIR/gnome-configuration.sh


## Mouse and Touchpad configuration
# There's no need to run these if you already run $SCRIPT_DIR/gnome-configuration.sh.
sudo su -c 'cat << EOF > /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
Section "InputClass"
    Identifier "My Mouse"
    Driver "libinput"
    MatchIsPointer "yes"
    Option "AccelProfile" "flat"
    Option "AccelSpeed" "0"
EndSection
EOF'

sudo su -c 'cat << EOF > /etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "My Touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lrm"
    Option "NaturalScrolling" "true"
    Option "AccelSpeed" "0.9"
    Option "AccelProfile" "flat"
EndSection
EOF'

## SysCTL
doas su -c 'cat << EOF > /etc/sysctl.d/99-sysctl.conf
# /etc/sysctl.d/99-sysctl.conf

net.core.netdev_max_backlog = 16384
net.core.somaxconn = 8192

net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 1048576
net.core.wmem_default = 1048576
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216

net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

net.ipv4.tcp_fastopen = 3

net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0

net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.default.send_redirects = 0
EOF'


## Generating a SSH Key for GitHub
if ( ! grep -q ".pub" <<< $(ls ~/.ssh 2>/dev/null)); then
  read -p "Enter your github email: " git_email
  read -p "Enter your github user name: " git_name

  ssh-keygen -t ed25519 -C "$git_email"

  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519

  echo -e "\033[1;29mThat's the key you have to copy:
  \033[0;32m$(cat ~/.ssh/id_ed25519.pub)\033[0m"

  git config --global user.name "$git_name"
  git config --global user.email $git_email
  git config --global core.editor nvim
  git config --global init.defaultBranch master
fi

echo -e"\n\nEverything is done!"