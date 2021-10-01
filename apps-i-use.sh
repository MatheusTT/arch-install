#!/bin/bash

if [ "$(whoami)" == "root" ]; then
    echo "Script must be run as a normal user"
    exit
fi

PACKAGES=(
    file-roller
    eog
    vlc
    gnome-{calculator,weather,passwordsafe}
    flatpak
    discord
    steam-native-runtime
    wine
    qbittorrent
    telegram-desktop
    bashtop
    neofetch
    powerline-vim
    powerline-fonts
    power-profiles-daemon
    ttf-font-awesome
)

AUR_PACKAGES=(
    google-chrome
    chrome-gnome-shell-git
    pfetch
    timeshift
    visual-studio-code-bin
    pop-shell-shortcuts-git
    gnome-shell-extension-pop-shell-git
    gnome-shell-extension-dash-to-dock-gnome40-git
    ideapad-cm
    lib32-mangohud
    mangohud
)
FLATPAKS=(
    org.gimp.GIMP
    org.kde.kdenlive
)

## Arch
echo -e "\033[1;34mArch Packages:\033[0m"

for package in ${PACKAGES[@]}; do
    if ! pacman -Qs | grep -q $package; then
        sudo pacman -S --noconfirm "$package"
    else
        echo -e "\033[0;32m[$package]\033[0m - already installed"
    fi
done

if ! pacman -Qm | grep -q paru-bin; then
    cd /tmp && git clone --depth=1 https://aur.archlinux.org/paru-bin.git
    cd paru-bin && makepkg -sic --noconfirm
fi

## AUR
echo -e "\n\033[1;34mAUR Packages:\033[0m"

for aur_pkg in ${AUR_PACKAGES[@]}; do
    if ! pacman -Qm | grep -q $aur_pkg; then
        paru -S --noconfirm "$aur_pkg"
    else
        echo -e "\033[0;32m[$aur_pkg]\033[0m - already installed"
    fi
done

## Flatpak

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo -e "\n\033[1;36mFlatpak Packages:\033[0m"

for flatpak_pkg in ${FLATPAKS[@]}; do
    if ! flatpak list | grep -q $flatpak_pkg; then
        flatpak install -y "$flatpak_pkg"
    else
        echo -e "\033[0;32m[$flatpak_pkg]\033[0m - already installed"
    fi
done

## PhotoGIMP

if flatpak list | grep -q org.gimp.GIMP; then
    cd ~/Downloads && wget https://github.com/Diolinux/PhotoGIMP/releases/download/1.0/PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip
    unzip PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip

    cd 'PhotoGIMP by Diolinux v2020 for Flatpak/'
    
    dirs_to_move=(
        .var
        .icons
        .local/share/applications
    )
    for path in ${dirs_to_move[@]}; do
        if [ ! -d ~/$path ]; then
            mkdir -p ~/$path
            mv $path/* ~/$path
        fi
            mv $path/* ~/$path
    done

    # This is because rofi doesn't show the Photogimp icon in ~/.icons,
    # but can show the icon that Papirus have.
    if find /usr/share/icons -name "photogimp*" | grep -q photogimp; then
        sed -i "s/.png//g" ~/.local/share/applications/org.gimp.GIMP.desktop
    fi

    cd .. && rm -rf 'PhotoGIMP by Diolinux v2020 for Flatpak'
    echo -e "\033[1;31mThe GIMP icon will change to PhotoGIMP after you restart.\033[0m"
fi

## Emojis

sudo pacman -S noto-fonts-emoji
mkdir ~/.config/fontconfig

echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n
<!-- ## serif ## -->\n  <alias>\n               <family>serif</family>\n                <prefer>\n                      <family>Noto Serif</family>\n                     <family>emoji</family>\n                        <family>Liberation Serif</family>\n
        <family>Nimbus Roman</family>\n                 <family>DejaVu Serif</family>\n         </prefer>\n     </alias>\n      <!-- ## sans-serif ## -->\n       <alias>\n               <family>sans-serif</family>\n           <prefer>\n                      <family>Noto Sans</family>\n                      <family>emoji</family>\n                        <family>Liberation Sans</family>\n                        <family>Nimbus Sans</family>\n                  <family>DejaVu Sans</family>\n          </prefer>\n     </alias>\n</fontconfig>' > /home/$USER/.config/fontconfig/fonts.conf

sudo fc-cache -f