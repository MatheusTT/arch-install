#!/bin/bash

sudo pacman -Syu

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

## AUR Helper
git clone https://aur.archlinux.org/pikaur.git /tmp/pikaur
cd /tmp/pikaur && makepkg -sic --noconfirm

## Themes, icons and the cursor
git clone https://github.com/dracula/gtk.git /tmp/Dracula
sudo mv /tmp/Dracula /usr/share/themes/

pikaur -S --noconfirm matcha-gtk-theme

sudo pacman -S --noconfirm papirus-icon-theme

sudo mv cz-Hickson-Black /usr/share/icons/

## Powerlevel10k and and pfetch
pikaur -S --noconfirm pfetch

pikaur -S --noconfirm nerd-fonts-meslo

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.local/share/powerlevel10k
echo 'source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme' >> $HOME/.zshrc


## Kitty conf
# first the fonts
sudo pacman -S --noconfirm ttf-fira-{code,mono,sans}

mv $SCRIPT_DIR/config_files/kitty.conf $HOME/.config/kitty/kitty.conf
