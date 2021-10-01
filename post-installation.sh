#!/bin/bash

# Directory where the script is
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


## AUR Helper
cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru-bin.git 
cd paru-bin && makepkg -sic --noconfirm


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

## Powerlevel10k and and pfetch
paru -S --noconfirm pfetch
paru -S --noconfirm nerd-fonts-meslo &&

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$USER/.local/share/powerlevel10k &&
echo "source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme" >> /home/$USER/.zshrc

## Kitty conf
# first the fonts
if ! pacman -Qs | grep -q ttf-fira-code; then
	sudo pacman -S --noconfirm ttf-fira-code
fi
if [ -f /home/$USER/.config/kitty/kitty.conf ]; then
    sudo mv /home/$USER/.config/kitty/kitty.conf /home/$USER/.config/kitty/default-kitty.conf
    sudo mv $SCRIPT_DIR/config_files/my-kitty.conf /home/$USER/.config/kitty/kitty.conf
else
    sudo mv $SCRIPT_DIR/config_files/my-kitty.conf /home/$USER/.config/kitty/kitty.conf
fi
## .vimrc
sudo mv $SCRIPT_DIR/config_files/.vimrc /home/$USER/

## pacman.conf
sudo sed -i "33s/.//;94,95s/.//;38i\ILoveCandy" /etc/pacman.conf

echo "

Everything is done!"
