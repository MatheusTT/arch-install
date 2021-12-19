#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    echo "Script must be run as a normal user"
    exit
fi

# Directory where the script is
SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"

## Reflector configuration
sudo su -c 'sed -i "s/^--/# --/" /etc/xdg/reflector/reflector.conf'
sudo su -c 'echo -e "
--country Brazil
--protocol \"https,http\"
--age 6
--sort rate
--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf'

## GTK Theme, icons, and the cursor theme
sudo pacman -S --noconfirm papirus-icon-theme

wget https://github.com/dracula/gtk/archive/master.zip -P /tmp/
unzip /tmp/master.zip -d /tmp
sudo mv /tmp/gtk-master /usr/share/themes/Dracula

sudo mv $SCRIPT_DIR/cz-Hickson-Black /usr/share/icons/

## Fonts
sudo pacman -S --noconfirm --needed ttf-fira-{code,mono,sans}

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


## Generating a SSH Key for GitHub
if ( ! grep -q ".pub" <<< $(ls ~/.ssh 2>/dev/null) ) ; then
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

fi

## Oh My Zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo "

Everything is done!"