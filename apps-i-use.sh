#!/bin/bash

PACKAGES=(
	discord
	steam
	wine
	qbittorrent
)

AUR_PACKAGES=(
	google-chrome
	pop-shell-shortcuts-git
	gnome-shell-extension-pop-shell-git
	pfetch
	timeshift
	visual-studio-code-bin
)
FLATPAKS=(
	org.telegram.desktop
	org.gimp.GIMP
	org.kde.kdenlive
	org.gnome.gitlab.somas.Apostrophe
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

if ! pacman -Qm | grep -q pikaur; then
	cd /tmp && git clone --depth=1 https://aur.archlinux.org/pikaur.git
	cd pikaur && makepkg -sic --noconfirm
fi

## AUR
echo -e "\n\033[1;34mAUR Packages:\033[0m"

for aur_pkg in ${AUR_PACKAGES[@]}; do
	if ! pacman -Qm | grep -q $aur_pkg; then
		pikaur -S --noconfirm "$aur_pkg"
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

if flatpak list | grep -q org.gnome.GIMP; then
	cd /home/$USER/Downloads && wget https://github.com/Diolinux/PhotoGIMP/releases/download/1.0/PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip

	unzip PhotoGIMP.by.Diolinux.v2020.for.Flatpak.zip
	cd PhotoGIMP\ by\ Diolinux\ v2020\ for\ Flatpak

	mv .icons /home/$USER
	mv .var /home/$USER
	mv .local/share/applicativos/org.gimp.GIMP.desktop /home/$USER/.local/share/applications/org.gimp.GIMP.desktop
	cd ..
	rm -rf PhotoGIMP\ by\ Diolinux\ v2020\ for\ Flatpak
fi
