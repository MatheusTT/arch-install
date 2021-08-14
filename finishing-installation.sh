#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc --utc

LANG="pt_BR.UTF-8 UTF-8"
sed -i "s/#$LANG/$LANG/" /etc/locale.gen
locale-gen

echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "
127.0.0.1	localhost
::1		localhost
127.0.1.1	arch.localdomain  arch" >> /etc/hosts


#echo -e "\n\033[1;32mPassword for root\033[0m"
#passwd root

useradd -mg users -G wheel -c Matheus -s /usr/bin/zsh broa
echo -e "\n\033[1;32mPassword for broa\033[0m"
passwd broa

sed -i "82s/./ /" /etc/sudoers


echo -e "\n\033[1;32mInstalling grub, networkmanager, reflector, etc.\033[0m"
pacman -Sy grub efibootmgr dosfstools os-prober mtools networkmanager reflector tlp

echo -e "\n\033[1;32mInstalling pipewire, wayland and xwayland\033[0m"
pacman -S pipewire pipewire-{alsa,jack,media-session,pulse} wayland xorg-xwayland 

#pacman -S nvidia nvidia-{utils,settings,prime} xf86-video-intel xf86-input-libinput

sed -i "52s/ keyboard//g" /etc/mkinitcpio.conf
sed -i "52s/ autodetect/ autodetect keyboard keymap/" /etc/mkinitcpio.conf
#sed -i "52s/ block/ block encrypt/" /etc/mkinitcpio.conf
mkinitcpio -p linux


echo -e "\n\033[1;32mgrub-install\033[0m"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch --recheck
echo -e "\n\033[1;32mgrub-mkconfig\033[0m"
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\033[1;32menabling some services\033[0m"
systemctl enable NetworkManager
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer

echo "
Now just do:
1. exit
2. umount -R /mnt
3. shutdown or reboot"
