# Hướng dẫn đóng góp — CaramOS

> [README tiếng Việt](README.md) · [English](CONTRIBUTING_EN.md)

---

## Kiến trúc dự án

CaramOS = **Arch Linux** + **CaramOS customization** (mkarchiso profile).

```
profile/                          # mkarchiso profile
├── profiledef.sh                 # ISO metadata, bootmodes, compression
├── packages.x86_64               # Arch packages to install
├── pacman.conf                   # pacman config (includes [caramos] repo)
├── airootfs/                     # Overlay files copied into rootfs
│   ├── etc/                      # Configs (dconf, lightdm, skel, locale)
│   ├── usr/share/                # Backgrounds, icons, themes, schemas
│   └── root/customize.sh         # Post-install customization script
├── syslinux/                     # BIOS boot config (branded)
├── grub/                         # GRUB boot config (branded)
└── efiboot/                      # systemd-boot UEFI (branded)
```

### Build flow

```
1. mkarchiso đọc profile/
2. Pacstrap packages từ packages.x86_64 (official repos + caramos-repo)
3. Copy overlay từ profile/airootfs/ vào rootfs
4. Chạy profile/airootfs/root/customize.sh (branding, services, cleanup)
5. Tạo squashfs → GRUB/syslinux/systemd-boot → ISO
```

## Build ISO

### Yêu cầu

- **Arch Linux** (native) hoặc **Docker** (mọi OS)
- Gói: `archiso`, `make`

### Build local

```bash
make build        # Dev build (lz4, nhanh)
make release      # Release build (xz, ISO nhỏ hơn)
make clean        # Xoá work/ và out/
make shell        # Vào chroot để debug
make test         # Boot ISO trong QEMU
```

### Build bằng Docker

```bash
make docker-build       # Build dev trong Docker
make docker-release     # Build release trong Docker
```

## Cách đóng góp

### Bạn có thể giúp gì?

| Vai trò | Công việc |
|---|---|
| **Tester** | Test ISO trên nhiều loại máy, báo lỗi |
| **Designer** | Wallpaper, icon, theme, branding |
| **Developer** | PKGBUILD, customize.sh, config |
| **Writer** | Tài liệu, dịch thuật |

### Quy trình đóng góp code

1. Fork repo → Clone → Tạo branch → Commit → Push → Pull Request

### Quy tắc Pull Request

- 1 PR = 1 tính năng hoặc 1 bug fix
- Mô tả rõ PR làm gì và tại sao
- Đã test trước khi tạo PR

## Bảng tra nhanh

| Task | Vị trí | Hành động |
|---|---|---|
| Thêm package | `profile/packages.x86_64` | Sửa file, build lại |
| Sửa config hệ thống | `profile/airootfs/etc/` | Sửa, build lại |
| Sửa theme/icons | `profile/airootfs/usr/share/` | Sửa, build lại |
| Sửa customize script | `profile/airootfs/root/customize.sh` | Sửa, build lại |
| Sửa boot config | `profile/syslinux/`, `profile/grub/` | Sửa, build lại |
| Thêm branding asset | `assets/` → copy vào `profile/airootfs/` | Copy + build lại |

## Tiêu chuẩn code

### Commit message — Conventional Commits

```
feat:     tính năng mới
fix:      sửa lỗi
docs:     tài liệu
chore:    build, config
brand:    wallpaper, logo, theme
```

---
