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

wget -nv https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MjU1ODA0OTIiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjU0MDg3NDllMTIyYjFkMGZjZGZhZWQ5OGIyMmY5ZDY4N2EyNDlkZDQxMGMwNmVjZGUxNTU4NzVlOWYwMTE3MmJiMGQwZWQ3MGE5YWEwZTljZGYxODk4YTVmYzliNmY0ZTM0YzZiNGRkYTRiNjJjYTNjNWJjN2Q0MjQ4NTI2Yzg5IiwidCI6MTYyNjk3NjI4OSwic3RmcCI6ImJlYzhmMGRmYTUyYzRjZWM1ZDY3NDgwNzMwNDM5NzdjIiwic3RpcCI6IjI4MDQ6ZDU1OjUyOTM6YzYwMDoxMDNkOmFiOGE6YTFmYjoyYjVkIn0.Fw-WWWDPGIr5gVX3fcPgjWcRguC6kCVvRWuvrKDzQXg/cz-Hickson-Black.zip

unzip cz-Hickson-Black.zip
mv cz-Hickson-Black /usr/share/icons/

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
