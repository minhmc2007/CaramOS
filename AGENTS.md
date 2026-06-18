# CaramOS — Arch-based Linux Distribution (mkarchiso)

## Tổng quan dự án

CaramOS là bản phân phối Linux dựa trên Arch Linux, thiết kế cho người dùng Việt Nam.
Phương pháp build: mkarchiso profile → packages + overlay + customize → ISO.

## Multi-repo Structure (managed via `repo` tool)

```
caramos-workspace/
├── core/        → CaramOS-Core   — mkarchiso ISO profile + build system
├── packages/    → CaramOS-Repo   — Custom Arch PKGBUILDs + pacman repo CI
├── manifest/    → CaramOS-Manifest — repo tool manifest XML
└── default.xml  → symlink to manifest/default.xml
```

### Setup workspace

```bash
repo init -u https://github.com/minhmc2007/CaramOS-Manifest
repo sync
```

## CaramOS-Core Structure

```
profile/                          # mkarchiso profile
├── profiledef.sh                 # Metadata (iso_name, bootmodes, compression)
├── packages.x86_64               # Packages to install
├── pacman.conf                   # pacman config (includes [caramos] repo)
├── airootfs/                     # Overlay files copied into rootfs
│   ├── etc/                      # Configs (dconf, lightdm, skel, locale, hostname)
│   ├── usr/share/                # applications, backgrounds, icons, themes
│   └── root/customize.sh         # Post-install customization script
├── syslinux/                     # BIOS boot config (branded)
├── grub/                         # GRUB config (branded)
└── efiboot/                      # systemd-boot UEFI (branded)
```

## CaramOS-Repo Structure

```
PKGBUILDs/         # Source PKGBUILDs
├── fcitx5-lotus/
├── lightdm-slick-greeter/
├── google-chrome/
├── wps-office-cn/
├── zalo/
├── xed/
├── xviewer/
├── xreader/
└── cinnamon-delight-theme/
repo/              # Generated pacman database + .pkg.tar.zst files
.github/workflows/ # CI: build packages → update repo → deploy to Pages
```

## Lệnh build

### Local Build (Arch Linux)

- `make build` — Dev build (lz4, nhanh)
- `make release` — Release build (xz, ISO nhỏ hơn)
- `make debug` — Debug build (verbose kernel log)
- `make clean` — Xoá work/ và out/
- `make shell` — Vào chroot để debug thủ công
- `make test` — Boot ISO trong QEMU (UEFI)

### Docker Build (Mọi hệ điều hành)

- `make docker-build` — Build dev trong Docker container
- `make docker-release` — Build release trong Docker container
- `make docker-clean` — Clean build qua Docker

### Quy trình build

```
1. mkarchiso đọc profile/
2. Pacstrap packages từ packages.x86_64 (official repos + caramos-repo)
3. Copy overlay từ profile/airootfs/ vào rootfs
4. Chạy profile/airootfs/root/customize.sh (branding, services, cleanup)
5. Tạo squashfs → GRUB/syslinux/systemd-boot → ISO
```

## Quy ước

### Customize Script

- Vị trí: `profile/airootfs/root/customize.sh`
- Chạy trong chroot SAU KHI packages + overlay đã applied
- Xử lý: branding, locale, services, desktop defaults, cleanup
- Thay thế tất cả các hook cũ (0100-foo.hook.chroot, 0200-bar.hook.chroot...)

### Kernel Boot Parameters

- Dev: `quiet splash` (Plymouth loading screen)
- Debug: `verbose` (hiện kernel log, tắt splash)

### Overlay Rules

- `profile/airootfs/etc/` — Config files ghi đè lên package defaults
- `profile/airootfs/usr/share/` — Assets (wallpapers, icons, themes, plymouth)
- Không include file tạm/large binary trong overlay

### Cấu hình Version

- `profile/profiledef.sh`: `iso_version`, `iso_label`
- Rolling release — `iso_version` = date (YYYY.MM.DD)

### Output

- ISO output: `out/caramos-YYYY-MM-DD-x86_64.iso`
- Work directory: `work/` (có thể xoá sau build)

## Lưu ý quan trọng

### Yêu cầu

- Build cần **Arch Linux** (native) hoặc Docker
- Yêu cầu gói: `archiso`, `make`
- Docker build hoạt động trên mọi hệ điều hành (macOS, Windows, Linux)

### CaramOS-Repo packages

Các package custom được build và host riêng tại repo `CaramOS-Repo`:
- fcitx5-lotus (thay vì fcitx5-unikey trên official repos)
- lightdm-slick-greeter (không có sẵn trên Arch)
- google-chrome, wps-office-cn, zalo
- xed, xviewer, xreader
- cinnamon-delight-theme

### CI/CD

- CaramOS-Core: GitHub Actions build ISO trên `archlinux:latest`
- CaramOS-Repo: GitHub Actions build PKGBUILDs, update pacman DB, deploy Pages

### Git Workflow

- Làm việc trong workspace: `repo start <branch> --all`
- Commit: `repo forall -c "git add -A && git commit -m 'msg'"`
- Push: `repo upload` hoặc `repo forall -c "git push"`

## Bảng tra nhanh

| Task                    | Vị trí                                        | Hành động                          |
| ----------------------- | --------------------------------------------- | ----------------------------------- |
| Thêm package            | `profile/packages.x86_64`                     | Sửa file, sau đó `make build`      |
| Build pkg cho repo      | `packages/PKGBUILDs/<tên>/PKGBUILD`             | Push lên CaramOS-Repo, CI build   |
| Sửa config hệ thống     | `profile/airootfs/etc/`                       | Sửa, sau đó `make build`           |
| Sửa theme/icons         | `profile/airootfs/usr/share/`                 | Sửa, sau đó `make build`           |
| Sửa boot config         | `profile/syslinux/`, `profile/grub/`, ...    | Sửa, sau đó `make build`           |
| Sửa customize script    | `profile/airootfs/root/customize.sh`          | Sửa, sau đó `make build`           |
| Thêm branding asset     | `assets/` → copy vào `profile/airootfs/`      | Copy + rebuild ISO                 |
| Debug trong chroot      | `make shell`                                  | Sau khi build một lần              |
| Test ISO trong QEMU     | `make test`                                   | Sau khi build                      |
