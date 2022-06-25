#!/bin/bash

if [[ "$(whoami)" == "root" ]]; then
  echo "Script must be run as a normal user" && exit
fi

PACKAGES=(
  file-roller
  eog
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
  rofi
  gcolor3
  ffmpegthumbnailer
  imagemagick
  virtualbox-host-modules-arch
  virtualbox
  gdu
  yt-dlp
)

AUR_PACKAGES=(
  google-chrome
  pfetch
  rxfetch
  timeshift
  visual-studio-code-bin
  lib32-mangohud-git
  mangohud-common-git
  spotify
  nerd-fonts-fira-code
  nerd-fonts-jetbrains-mono
  ttf-twemoji
  ttf-ms-fonts
  mugshot
)
FLATPAKS=(
  org.gimp.GIMP
  org.kde.kdenlive
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


for aur_pkg in ${AUR_PACKAGES[@]}; do
  if ( ! pacman -Qs "^$aur_pkg" >/dev/null ); then
    echo -e "\033[0;32m[$aur_pkg]\033[0m - Installing..."
    paru -S --noconfirm "$aur_pkg" &&
    echo -e "\033[0;32m[$aur_pkg]\033[0m - Installed successfully!\n"
  else
    echo -e "\033[0;32m[$aur_pkg]\033[0m - Already installed"
  fi
done



## Flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo -e "\n\033[1;36mFlatpak Packages:\033[0m"
flatpak install -y ${FLATPAKS[@]}


## Must enable cronie.service for timeshift to work
sudo systemctl enable cronie.service


## PhotoGIMP
if ( flatpak list | grep -q org.gimp.GIMP ) && [[ ! -f ~/.local/share/applications/org.gimp.GIMP.desktop ]]; then
  cd ~/Downloads && wget https://github.com/Diolinux/PhotoGIMP/releases/download/1.0/PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip
  unzip PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip

  cd 'PhotoGIMP by Diolinux v2020 for Flatpak/'
  
  dirs_to_move=(
    .var
    .icons
    .local/share/applications
  )
  for path in ${dirs_to_move[@]}; do
    if [[ ! -d ~/$path ]]; then
      mkdir -p ~/$path
      mv $path/* ~/$path
    else
      mv $path/* ~/$path
    fi
  done

  # This is because rofi doesn't show the PhotoGIMP icon in ~/.icons,
  # but can show the icon that Papirus have.
  if ( find /usr/share/icons -name "photogimp*" >/dev/null ); then
    sed -i "s/.png//g" ~/.local/share/applications/org.gimp.GIMP.desktop
  fi

  cd .. && rm -rf 'PhotoGIMP by Diolinux v2020 for Flatpak'
  echo -e "\033[1;31mThe GIMP icon will change to PhotoGIMP after you restart.\033[0m"
fi

## Emojis
sudo ln -sf /usr/share/fontconfig/conf.avail/75-twemoji.conf /etc/fonts/conf.d/75-twemoji.conf
sudo fc-cache -f