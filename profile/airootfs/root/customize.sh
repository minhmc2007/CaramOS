#!/bin/bash
# CaramOS — live ISO customization script
# Runs inside mkarchiso chroot after package installation
set -euo pipefail

echo "[CaramOS] === Starting customization ==="

# --------------------------------------------------
# Identity & branding
# --------------------------------------------------
echo "caramos" > /etc/hostname
sed -i 's/archiso/caramos/g' /etc/hosts

cat > /etc/os-release <<'EOF'
NAME="CaramOS"
ID=caramos
ID_LIKE="arch"
PRETTY_NAME="CaramOS (rolling) Cinnamon"
HOME_URL="https://github.com/minhmc2007/CaramOS"
SUPPORT_URL="https://github.com/minhmc2007/CaramOS/issues"
EOF

# --------------------------------------------------
# Root account (unlock for live session)
# --------------------------------------------------
passwd -d root

# --------------------------------------------------
# Locale & timezone
# --------------------------------------------------
sed -i 's/#vi_VN.UTF-8/vi_VN.UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=vi_VN.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
echo "Asia/Ho_Chi_Minh" > /etc/timezone

# --------------------------------------------------
# Plymouth boot splash (use bgrt theme if caramos theme missing)
# --------------------------------------------------
if [ -f /usr/share/plymouth/themes/caramos/caramos.plymouth ]; then
    plymouth-set-default-theme caramos -R 2>/dev/null || true
fi

# --------------------------------------------------
# ZRAM (50% RAM)
# --------------------------------------------------
cat > /etc/systemd/zram-generator.conf <<'ZRAM'
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
ZRAM

# --------------------------------------------------
# Services enable
# --------------------------------------------------
systemctl enable NetworkManager.service
systemctl enable lightdm.service
systemctl enable systemd-resolved.service
# fcitx5-lotus-server@root.service  # TODO: enable when fcitx5-lotus is available

# --------------------------------------------------
# Live session: root autologin via LightDM
# --------------------------------------------------
mkdir -p /etc/lightdm/lightdm.conf.d
cat > /etc/lightdm/lightdm.conf.d/50-caramos-autologin.conf <<'LIGHTDM'
[Seat:*]
autologin-user=root
autologin-session=cinnamon
user-session=cinnamon
greeter-session=slick-greeter
LIGHTDM

# --------------------------------------------------
# Desktop branding (dconf)
# --------------------------------------------------
if command -v dconf >/dev/null 2>&1; then
    dconf update || true
fi
glib-compile-schemas /usr/share/glib-2.0/schemas/ || true
gtk-update-icon-cache -f /usr/share/icons/hicolor >/dev/null 2>&1 || true

# --------------------------------------------------
# Remove bloat
# --------------------------------------------------
pacman -Rns --noconfirm gnome-music totem epiphany 2>/dev/null || true

# --------------------------------------------------
# Cleanup
# --------------------------------------------------
pacman -Scc --noconfirm 2>/dev/null || true
rm -rf /tmp/* /var/tmp/*
rm -f /etc/resolv.conf

echo "[CaramOS] === Customization complete ==="
date -u +"%Y-%m-%dT%H:%M:%SZ" > /etc/caramos-customized
