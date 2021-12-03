#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    echo "Script must be run as a normal user"
    exit
fi

# Directory where the script is
SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"


## GTK Theme, icons, and the cursor theme
paru -S --noconfirm matcha-gtk-theme papirus-icon-theme

sudo mv $SCRIPT_DIR/cz-Hickson-Black /usr/share/icons/

## Fonts
for font in ttf-fira-{code,mono,sans}; do
    if ! pacman -Qs | grep -q $font; then
        sudo pacman -S --noconfirm "$font"
    fi
done

## Gnome configuration
sh $SCRIPT_DIR/gnome-configuration.sh

echo "

Everything is done!"