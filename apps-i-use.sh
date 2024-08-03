#!/bin/bash

if [[ "$(whoami)" == "root" ]]; then
  echo "Script must be run as a normal user" && exit
fi

PACKAGES=(
  file-roller
  imv
  vlc
  blueberry
  gnome-calculator
  flatpak
  discord
  steam-native-runtime
  qbittorrent
  telegram-desktop
  btop
  ranger
  python-pillow
  neofetch
  gcolor3
  ffmpegthumbnailer
  cronie
  imagemagick
  gdu
  fzf
  yt-dlp
  mangohud
  lib32-mangohud
  ttf-jetbrains-mono-nerd
)

AUR_PACKAGES=(
  google-chrome
  brave-bin
  visual-studio-code-bin
  spotify
  ttf-twemoji
)


## Arch
echo -e "\033[1;34mArch Packages:\033[0m"
sudo pacman -S --needed --noconfirm ${PACKAGES[@]}


## AUR
echo -e "\n\033[1;34mAUR Packages:\033[0m"
if ( ! pacman -Qs "^paru" >/dev/null ); then
  cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru.git 1>/dev/null
  cd paru && makepkg -sic --noconfirm 1>/dev/null 
fi

paru -S --needed --noconfirm ${AUR_PACKAGES[@]}


## Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Must enable cronie.service for timeshift to work
sudo systemctl enable cronie.service

## Emojis
sudo ln -sf /usr/share/fontconfig/conf.avail/75-twemoji.conf /etc/fonts/conf.d/75-twemoji.conf
sudo fc-cache -f

## Steam
cp /usr/share/applications/steam*.desktop $HOME/.local/share/applications/
sed -i "/^X-KDE-RunOnDiscreteGpu=.*/a NoDisplay=true" $HOME/.local/share/applications/steam.desktop
sed -i "s/Steam (Native)/Steam/" $HOME/.local/share/applications/steam-native.desktop
