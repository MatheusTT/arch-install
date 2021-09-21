#!/bin/bash

PACKAGES=(
    file-roller
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
	cd /home/$USER/Downloads && wget https://github.com/Diolinux/PhotoGIMP/releases/download/1.0/PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip
    unzip PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip

    cd 'PhotoGIMP by Diolinux v2020 for Flatpak'
	mv .icons /home/$USER/
	mv .var /home/$USER/
	mv .local/share/applicativos/org.gimp.GIMP.desktop /home/$USER/.local/share/applications

    cd .. && rm -rf 'PhotoGIMP by Diolinux v2020 for Flatpak'
    echo -e "\033[1;31mThe GIMP icon will change to PhotoGIMP after you restart.\033[0m"
fi
