#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    echo "Script must be run as a normal user"
    exit
fi

# Directory where the script is
SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"


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
    Option "AccelSpeed" "0"
    Option "AccelProfile" "flat"
EndSection
EOF'

echo "

Everything is done!"