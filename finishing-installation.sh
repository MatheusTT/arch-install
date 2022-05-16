#!/bin/bash

LANG="pt_BR.UTF-8"
LANG2="en_US.UTF-8"
KEYMAP="br-abnt2"
COUNTRY="Brazil"
TIMEZONE="America/Sao_Paulo"

USERNAME="broa"
USERSHELL="/usr/bin/zsh"
HOSTNAME="arch"
BOOTLOADER_ID="Arch"

USE_DOAS=true

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc --utc

pacman -Syy rsync reflector

reflector -c $COUNTRY -a 6 --sort rate --save /etc/pacman.d/mirrorlist
## Reflector configuration
sed -i "s/^--/# --/" /etc/xdg/reflector/reflector.conf
echo -e "
--country $COUNTRY
--protocol \"https,http\"
--age 6
--sort rate
--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf


for i in 33 37 93 94 ; do
  sed -i "$i s/#//" /etc/pacman.conf
done
sed -i "38i\ILoveCandy" /etc/pacman.conf

sed -i "s/#$LANG/$LANG/" /etc/locale.gen
sed -i "s/#$LANG2/$LANG2/" /etc/locale.gen
locale-gen

echo "LANG=$LANG" >> /etc/locale.conf
echo "KEYMAP=$KEYMAP" >> /etc/vconsole.conf

echo "$HOSTNAME" >> /etc/hostname
echo "
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain  $HOSTNAME" >> /etc/hosts


#echo -e "\n\033[1;32mPassword for root\033[0m"
#passwd root

useradd -mg users -G wheel -s $USERSHELL $USERNAME
echo -e "\n\033[1;32mPassword for $USERNAME\033[0m"
passwd $USERNAME

if $USE_DOAS ; then
  #root privileges with doas
  pacman -Rns sudo && pacman -S opendoas
  ln -s $(which doas) /usr/bin/sudo
  cat << EOF > /etc/doas.conf
permit persist :wheel as root
permit :wheel as root cmd su
EOF
else
  #root privileges with sudo
  sed -i "82s/./ /" /etc/sudoers
fi

echo -e "\n\033[1;32mInstalling grub, networkmanager, wget, etc.\033[0m"
# You can add "os-prober" here, if you have more than one OS.
pacman -Syy grub efibootmgr dosfstools mtools networkmanager xdg-{utils,user-dirs} wget man-db ntfs-3g gufw tlp libappimage

echo -e "\n\033[1;32mInstalling pipewire, xorg and bluez\033[0m"
pacman -S pipewire pipewire-{alsa,jack,pulse} wireplumber xorg xorg-apps bluez bluez-utils 

#pacman -S nvidia nvidia-{utils,settings} lib32-nvidia-utils

LC_ALL=C xdg-user-dirs-update --force

sed -i "52s/ keyboard//g" /etc/mkinitcpio.conf
sed -i "52s/autodetect/autodetect keyboard keymap/" /etc/mkinitcpio.conf
#sed -i "52s/block/block encrypt/" /etc/mkinitcpio.conf
mkinitcpio -p linux


echo -e "\n\033[1;32mgrub-install\033[0m"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=$BOOTLOADER_ID --recheck
#vim /etc/default/grub
echo -e "\n\033[1;32mgrub-mkconfig\033[0m"
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\033[1;32menabling some services\033[0m"
systemctl enable NetworkManager
systemctl enable ufw
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer

echo "
Now just do:
1. exit
2. umount -R /mnt
3. shutdown or reboot"