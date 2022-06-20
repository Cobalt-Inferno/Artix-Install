echo -e "d\nd\nd\nd\n\n\nw" | fdisk /dev/nvme0n1
echo -e "n\np\n1\n\n+1G\nw" | fdisk /dev/nvme0n1
echo -e "n\np\n2\n\n+16G\nw" | fdisk /dev/nvme0n1
echo -e "n\np\n3\n\n\nw" | fdisk /dev/nvme0n1
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
mount /dev/nvme0n1p2 /mnt
swapon /dev/nvme0n1p2
basestrap /mnt base base-devel openrc elogind-openrc linux linux-firmware nano neofetch
fstabgen -U /mnt >> /mnt/etc/fstab
cat << EOF | artix-chroot /mnt
locale-gen
export LANG="en_US.UTF-8"
export LC_COLLATE="C"
echo keroeslux-artix > /etc/hostname
touch /etc/hosts
echo "127.0.0.1     localhost" > /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     aslen-pc" >> /etc/hosts
pacman -S dhclient connman-openrc connman-gtk --noconfirm
echo 'hostname="keroeslux-artix"' > /etc/conf.d/hostname
rc-update add connmand
echo -e "test\ntest" | passwd root
yes | pacman -S grub efibootmgr
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m keroeslux
echo -e "test\ntest" | passwd aslen
yes | pacman -S sudo nano
sed -i '80i keroeslux ALL=(ALL) ALL' /etc/sudoers
pacman -S --noconfirm xorg-xinit xorg git 
pacman -Syy
cd /home/keroeslux/
git clone https://github.com/keroeslux/vreri
cd vreri
chmod +x bspwm.sh
./bspwm.sh
EOF
