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
DO_ENCRYPTION=false

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc --utc

pacman --noconfirm -Syy rsync reflector

reflector -c $COUNTRY -a 6 --sort rate --save /etc/pacman.d/mirrorlist
## Reflector configuration
sed -i "s/^--/# --/" /etc/xdg/reflector/reflector.conf
echo -e "
--country $COUNTRY
--protocol \"https,http\"
--age 6
--sort rate
--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf

## Configuring pacman
sed -i 's/#ParallelDownloads/ParallelDownloads' /etc/pacman.conf
sed -i 's/#Color/Color' /etc/pacman.conf
sed -i '/ParallelDownloads/ a\ILoveCandy\' /etc/pacman.conf
sed -i 's/\#[multilib\]/\[multilib\]/' /etc/pacman.conf
sed -i '/\[multilib\]/{n;s/#Include/Include/;}' /etc/pacman.conf
pacman -Syy

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

echo "options timeout:1
options single-request

nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8" | tee /etc/resolv.conf
chattr +i /etc/resolv.conf


#echo -e "\n\033[1;32mPassword for root\033[0m"
#passwd root

useradd -mg users -G wheel,input,video -s $USERSHELL $USERNAME
echo -e "\n\033[1;32mPassword for $USERNAME\033[0m"
passwd $USERNAME

if $USE_DOAS; then
  #root privileges with doas
  pacman -Rns --noconfirm sudo && pacman -S --noconfirm opendoas
  ln -s $(which doas) /usr/bin/sudo
  cat << EOF > /etc/doas.conf
permit persist :wheel as root
permit :wheel as root cmd su
EOF
else
  #root privileges with sudo
  sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
fi

echo -e "\n\033[1;32mInstalling grub, networkmanager, wget, etc.\033[0m"
# You can add "os-prober" here, if you have more than one OS.
pacman --noconfirm -S grub efibootmgr dosfstools networkmanager xdg-utils wget man-db ntfs-3g gufw tlp libappimage irqbalance

echo -e "\n\033[1;32mInstalling pipewire and bluez\033[0m"
pacman --noconfirm -S pipewire pipewire-{alsa,jack,pulse} wireplumber bluez bluez-utils 

#pacman -S nvidia nvidia-{utils,settings} lib32-nvidia-utils
pacman -S vulkan-radeon lib32-vulkan-radeon mesa

sed -i "52s/ keyboard//g" /etc/mkinitcpio.conf
sed -i "52s/autodetect/autodetect keyboard keymap/" /etc/mkinitcpio.conf

if $DO_ENCRYPTION; then
  sed -i "52s/block/block encrypt/" /etc/mkinitcpio.conf

  CRYPT_UUID=$(lsblk -f | awk '/crypto_LUKS/ { print $4 }')
  CRYPT_NAME="cryptroot"
  KERNEL_PARAMETER="cryptdevice=UUID=$CRYPT_UUID:cryptroot root=/dev/mapper/$CRYPT_NAME"
  sed -i "s+CMDLINE_LINUX=\"+&$KERNEL_PARAMETER+" /etc/default/grub
  sed -i "s/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/" /etc/default/grub
fi

mkinitcpio -p linux


echo -e "\n\033[1;32mgrub-install\033[0m"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=$BOOTLOADER_ID --recheck
#vim /etc/default/grub
echo -e "\n\033[1;32mgrub-mkconfig\033[0m"
grub-mkconfig -o /boot/grub/grub.cfg

## Blacklisting some kernel modules
echo "blacklist iTCO_wdt
blacklist sp5100_tco
blacklist pcspkr
blacklist joydev
blacklist mousedev
blacklist mac_hid" | tee /etc/modprobe.d/blacklist.conf


echo -e "\033[1;32menabling some services\033[0m"
systemctl enable NetworkManager.service
systemctl enable ufw.service
systemctl enable tlp.service
systemctl enable irqbalance.service
systemctl enable reflector.timer
systemctl enable fstrim.timer

## Setting up ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 25565
ufw enable

echo "
Now just do:
1. exit
2. umount -R /mnt
3. shutdown or reboot"
