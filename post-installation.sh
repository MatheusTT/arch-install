#!/bin/bash

# Directory where the script is
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


## AUR Helper
cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru-bin.git 
cd paru-bin && makepkg -sic --noconfirm


## GTK Theme, icons, and the cursor theme
paru -S --noconfirm matcha-gtk-theme papirus-icon-theme

sudo mv $SCRIPT_DIR/cz-Hickson-Black /usr/share/icons/

gsettings set org.gnome.desktop.interface gtk-theme     "Matcha-dark-azul"
gsettings set org.gnome.desktop.interface icon-theme    "Papirus"
gsettings set org.gnome.desktop.interface cursor-theme  "cz-Hickson-Black"

sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface icon-theme    "Papirus"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme  "cz-Hickson-Black"

## Mouse/touchpad settings
gsettings set org.gnome.desktop.peripherals.mouse accel-profile   "flat"
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click  true

sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.mouse accel-profile   "flat"
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click  true

## Keyboard layout
gsettings set org.gnome.desktop.input-sources sources "[('xkb','br')]"

## Fonts
for font in ttf-fira-{code,mono,sans}; do
	if ! pacman -Qs | grep -q $font; then
		sudo pacman -S --noconfirm "$font"
	fi
done

gsettings set org.gnome.desktop.interface font-name           'Fira Sans 12'
gsettings set org.gnome.desktop.interface document-font-name  'Fira Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Medium 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font  'Fira Sans Bold 12'

## Night-light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled       true
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to   0
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature   3150

sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled       true
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to   0
sudo -u gdm dbus-launch gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature   3150

## Other gsettings
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 1800

gsettings set org.gnome.desktop.wm.preferences button-layout "appmenu:minimize,maximize,close"
gsettings set org.gnome.desktop.interface enable-hot-corners true
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

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
