#!/bin/bash

# Directory where the script is
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


## AUR Helper
cd /tmp && git clone --depth=1 https://aur.archlinux.org/pikaur.git
cd pikaur && makepkg -sic --noconfirm


## Themes, icons and the cursor
git clone --depth=1 https://github.com/dracula/gtk.git /tmp/Dracula
sudo mv /tmp/Dracula /usr/share/themes/
gsettings set org.gnome.desktop.interface gtk-theme "Dracula"

pikaur -S --noconfirm matcha-gtk-theme

sudo pacman -S --noconfirm papirus-icon-theme
gsettings set org.gnome.desktop.interface icon-theme "Papirus"

sudo mv $SCRIPT_DIR/cz-Hickson-Black /usr/share/icons/
gsettings set org.gnome.desktop.interface cursor-theme "cz-Hickson-Black"


## Powerlevel10k and and pfetch
pikaur -S --noconfirm pfetch

pikaur -S --noconfirm nerd-fonts-meslo &&

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USER/.local/share/powerlevel10k &&
echo 'source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme' >> /home/$USER/.zshrc


## Kitty conf
# first the fonts
sudo pacman -S --noconfirm ttf-fira-{code,mono,sans} &&
mv $SCRIPT_DIR/config_files/kitty.conf /home/$USER/.config/kitty/kitty.conf

## .vimrc
mv $SCRIPT_DIR/config_files/.vimrc /home/$USER

## pacman.conf
sudo mv $SCRIPT_DIR/config_files/pacman.conf /etc/pacman.conf &&
sudo pacman -Sy

echo "

Everything is done! "
