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
::1		localhost
127.0.1.1	arch.localdomain  arch" >> /etc/hosts


#echo -e "\n\033[1;32mPassword for root\033[0m"
#passwd root

useradd -mg users -G wheel -c Matheus -s /usr/bin/zsh broa
echo -e "\n\033[1;32mPassword for broa\033[0m"
passwd broa

sed -i "82s/./ /" /etc/sudoers


pacman -S grub efibootmgr dosfstools os-prober mtools networkmanager bluez tlp reflector xdg-{utils,user-dirs} pipewire pipewire-{alsa,jack,media-session,pulse} wayland xorg-xwayland ttf-fira-{code,mono,sans}

#pacman -S nvidia nvidia-{utils,settings,prime} mesa xf86-video-intel xf86-input-libinput

sed -i "52s/ keyboard//g" /etc/mkinitcpio.conf
sed -i "52s/ autodetect/ autodetect keyboard keymap/" /etc/mkinitcpio.conf
sed -i "52s/ block/ block encrypt/" /etc/mkinitcpio.conf
mkinitcpio -P


echo -e "\n\033[1;32mgrub-install\033[0m"
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --recheck
echo -e "\n\033[1;32mgrub-mkconfig\033[0m"
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\033[1;32menabling some services\033[0m"
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer

echo "
Now just do:
1. exit
2. umount -R /mnt
3. shutdown or reboot
"
