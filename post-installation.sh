#!/bin/bash

sudo pacman -Syu

## AUR Helper
git clone https://aur.archlinux.org/pikaur.git /tmp/pikaur
cd /tmp/pikaur && makepkg -sic

## Themes, icons and the cursor
git clone https://github.com/dracula/gtk.git /tmp/Dracula
sudo mv /tmp/Dracula /usr/share/themes/

pikaur -S --noconfirm matcha-gtk-theme

sudo pacman -S --noconfirm papirus-icon-theme

sudo cz-Hickson-Black /usr/share/icons/

## Powerlevel10k and zsh (and pfetch)
pikaur -S --noconfirm pfetch

pikaur -S --noconfirm nerd-fonts-meslo

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.local/share/powerlevel10k
echo 'source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme' >> $HOME/.zshrc

sudo pacman -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions

echo "
## For saving commands 
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

## Plugins
# zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

## My own commands
ZLE_RPROMPT_INDENT=0
pfetch" >> $HOME/.zshrc

## Kitty conf
# first the fonts
sudo pacman -S --noconfirm ttf-fira-{code,mono,sans}

cp ./config_files/kitty.conf $HOME/.config/kitty/
