#!/bin/bash

# Directory where the script is
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


## AUR Helper
cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru-bin.git 
cd paru-bin && makepkg -sic --noconfirm


## Themes, icons, the cursor theme and general gsettings configurations
paru -S --noconfirm matcha-gtk-theme
gsettings set org.gnome.desktop.interface gtk-theme "Matcha-dark-azul"

sudo pacman -S --noconfirm papirus-icon-theme
gsettings set org.gnome.desktop.interface icon-theme "Papirus"

sudo mv $SCRIPT_DIR/cz-Hickson-Black /usr/share/icons/
gsettings set org.gnome.desktop.interface cursor-theme "cz-Hickson-Black"

gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

gsettings set org.gnome.desktop.session idle-delay 0


sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme 'cz-Hickson-Black'
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.mouse accel-profile 'flat'

# keyboard layout

gsettings set org.gnome.desktop.input-sources sources "[('xkb','br')]"

# fonts

for font in ttf-fira-{code,mono,sans}; do
	if ! pacman -Qs | grep -q $font; then
		sudo pacman -S --noconfirm "$font"
	fi
done

gsettings set org.gnome.desktop.interface font-name           'Fira Sans 12'
gsettings set org.gnome.desktop.interface document-font-name  'Fira Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Medium 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font  'Fira Sans Bold 12'

# night-light

gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled       true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to   0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature   3150

# night-light for gdm

sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled       true
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to   0
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature   3150

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
sudo sed -i "33s/.//;94,95s/.//;38i\ILoveCandy"

echo "

Everything is done!"
