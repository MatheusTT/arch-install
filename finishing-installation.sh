#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc --utc

LINE=$(grep -n "pt_BR.UTF-8 UTF-8" /etc/locale.gen | cut -d : -f 1)
sed -i '$LINE s/.//' /etc/locale.gen
locale-gen

echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "
127.0.0.1	localhost
::1			localhost
127.0.1.1	arch.localdomain  arch" >> /etc/hosts


passwd root
useradd -mg users -G wheel -c Matheus -s /usr/bin/zsh broa
passwd broa

sed -i "82s/./ /" /etc/sudoers

pacman -S grub efibootmgr dosfstools os-prober mtools networkmanager bluez tlp reflector xdg-{utils,user-dirs} pipewire pipewire-{alsa,jack,media-session,pulse} wayland xorg-xwayland

pacman -S nvidia nvidia-{utils,settings,prime} mesa xf86-video-intel xf86-input-libinput

grub-install --target=x86_64-efi --efi-directory=/boot/efi -bootloader-id=Arch --recheck &&
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable tlp
systemctl enable reflector.timer

echo "
Now just do:
1. exit
2. umount -R /mnt
3. shutdown or reboot
"