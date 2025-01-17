#!bin/bash

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# Install linux kernel & basic tools
pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager git neovim

echo "> Generate fstab file"
genfstab -U /mnt >> /mnt/etc/fstab

echo "> Changing root"
arch-chroot /mnt

# Time
echo "> Set local time"
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
echo "> generate /etc/adjtime"
hwclock --systohc

# Locales
#edit locale.gen ?
echo "> Generate locales"
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf

# hostname ?

# Initramfs
mkinitcpio -P

# Enter new Root password
echo "> Set new ROOT passwd"
passwd

# Install new GRUB
pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

echo "> Install finish please reboot!"
