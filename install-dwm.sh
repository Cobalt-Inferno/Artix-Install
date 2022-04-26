echo -e "d\nd\nd\nd\n\n\nw" | fdisk /dev/vda
echo -e "n\np\n1\n\n+1G\nw" | fdisk /dev/vda
echo -e "n\np\n2\n\n\nw" | fdisk /dev/vda
mkfs.fat -F32 /dev/vda1
mkfs.ext4 /dev/vda2
mount /dev/vda2 /mnt
basestrap /mnt base base-devel openrc elogind-openrc linux linux-firmware nano neofetch
fstabgen -U /mnt >> /mnt/etc/fstab
cat << EOF | artix-chroot /mnt
locale-gen
export LANG="en_US.UTF-8"
export LC_COLLATE="C"
echo aslen-pc > /etc/hostname
touch /etc/hosts
echo "127.0.0.1     localhost" > /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     aslen-pc" >> /etc/hosts
pacman -S dhclient connman-openrc connman-gtk --noconfirm
echo 'hostname="aslen-pc"' > /etc/conf.d/hostname
rc-update add connmand
echo -e "test\ntest" | passwd root
yes | pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/vda1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m aslen
echo -e "test\ntest" | passwd aslen
yes | pacman -S sudo nano
sed -i '80i aslen ALL=(ALL) ALL' /etc/sudoers
pacman -S --noconfirm xorg-xinit xorg git 
cd /usr/src
git clone git://git.suckless.org/dwm
git clone git://git.suckless.org/st
git clone git://git.suckless.org/dmenu
cd dwm
make clean install
cd ..
cd st
make clean install
cd ..
cd dmenu
make clean install
cd ..
pacman -Syy
echo 'Login as a user, then type 'nano ~/.xinitrc' and add "exec dwm" to it'
EOF
