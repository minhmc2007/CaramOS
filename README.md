<p align="center">
  <img src="assets/CaramOS_logo.png" alt="CaramOS Logo" width="250">
</p>

<h1 align="center">CaramOS</h1>

<p align="center">
  <strong>Sweet & Simple Linux — Hệ điều hành Linux ngọt ngào cho người Việt</strong>
</p>

<p align="center">
  <em>Caram = Carambola = Trái khế — 5 cánh như ngôi sao trên quốc kỳ, gắn liền với tuổi thơ người Việt</em>
</p>

<p align="center">
  <a href="README_EN.md">English</a> · <a href="https://vietnamlinuxfamily.net">VNLF</a> · <a href="https://caramos.vietnamlinuxfamily.net">Website</a>
</p>

<p align="center">
  Phát triển bởi: <a href="https://www.facebook.com/groups/vietnamlinuxcommunity">VNLF</a> · <a href="https://www.facebook.com/mrd.900s/">MRD</a> · <a href="https://www.facebook.com/tam.nguyet.that">Kỳ Nguyễn</a>
</p>

---

## CaramOS là gì?

**CaramOS** là bản phân phối Linux dựa trên **Arch Linux**, sử dụng desktop **Cinnamon**,
được thiết kế đặc biệt cho **người dùng Việt Nam**.
Dự án sử dụng **mkarchiso** để build ISO trực tiếp từ Arch Linux.

Mục tiêu của CaramOS là phổ thông hoá Linux — giúp người dùng Việt chuyển từ
Windows sang Linux dễ hơn, có sẵn giao diện thân thiện, bộ gõ tiếng Việt,
trình duyệt, ứng dụng văn phòng và các tiện ích quen thuộc.

## Tính năng nổi bật

| Tính năng | Mô tả |
|---|---|
| **Dựa trên Arch Linux** | Rolling release, luôn cập nhật phần mềm mới nhất, AUR |
| **Giao diện CaramOS** | Branding CaramOS, boot menu/Plymouth, logo, wallpaper, panel và theme được tuỳ biến |
| **Tiếng Việt mặc định** | Locale Việt Nam, timezone Asia/Ho_Chi_Minh |
| **Bộ gõ tiếng Việt** | Fcitx5 + Lotus được cài và cấu hình sẵn |
| **Google Chrome** | Trình duyệt phổ biến được cài sẵn |
| **WPS Office** | Bộ ứng dụng văn phòng thân thiện với người dùng chuyển từ Windows |
| **Zalo** | Zalo được cài sẵn và có shortcut ngoài Desktop |
| **Cinnamon Delight + Tela/Bibata** | Theme, icon và cursor hiện đại, nhẹ, dễ nhìn |
| **Build linh hoạt** | Dev build nhanh bằng `lz4`, release build nhỏ hơn bằng `xz`, hỗ trợ Docker |

<p align="center">
  <img src="assets/caramos_vietnam_banner.png" alt="CaramOS banner" width="900">
</p>

## Trải nghiệm CaramOS

| Bước | Hình ảnh |
|---|---|
| **1. GRUB boot menu**<br>Chọn live session hoặc cài đặt CaramOS. | <img src="assets/screenshots/01-grub-menu.png" alt="CaramOS GRUB boot menu" width="420"> |
| **2. Startup loading**<br>Màn hình khởi động/Plymouth branding. | <img src="assets/screenshots/02-startup-loading.png" alt="CaramOS startup loading screen" width="420"> |
| **3. Desktop**<br>Giao diện Cinnamon đã tuỳ biến theme, icon, panel và wallpaper. | <img src="assets/screenshots/03-desktop.png" alt="CaramOS Cinnamon desktop" width="420"> |
| **4. Neofetch**<br>Thông tin hệ thống và nhận diện CaramOS trong terminal. | <img src="assets/screenshots/04-neofetch.png" alt="CaramOS neofetch output" width="420"> |

## Công nghệ sử dụng

| Thành phần | Công nghệ |
|---|---|
| **Base** | Arch Linux (rolling) |
| **Desktop** | Cinnamon |
| **Display manager** | LightDM + Slick Greeter |
| **Build method** | mkarchiso (profile → packages + overlay + customize → ISO) |
| **Compression dev** | SquashFS `lz4` |
| **Compression release** | SquashFS `xz` |
| **Theme** | Cinnamon Delight |
| **Icons** | Tela Circle |
| **Cursor** | Bibata |
| **Input method** | Fcitx5 + Lotus |
| **Browser** | Google Chrome |
| **Office** | WPS Office |
| **Chat** | Zalo |

## Cấu trúc dự án

```
CaramOS-Core/
├── profile/                          # mkarchiso profile
│   ├── profiledef.sh                 # ISO metadata, boot modes, compression
│   ├── packages.x86_64               # Arch packages to install
│   ├── pacman.conf                   # pacman config (includes [caramos] repo)
│   ├── airootfs/                     # Overlay files → copied into rootfs
│   │   ├── etc/                      # Configs (dconf, lightdm, skel, locale)
│   │   ├── usr/share/                # Backgrounds, icons, themes, schemas
│   │   └── root/customize.sh         # Post-install customization script
│   ├── grub/                         # GRUB boot config (branded)
│   ├── syslinux/                     # Syslinux BIOS boot config (branded)
│   └── efiboot/                      # systemd-boot UEFI config
├── assets/                           # Logo, wallpapers, screenshots
├── Makefile                          # Build targets
├── Dockerfile                        # Build container (archlinux:latest)
└── docker-compose.yml
```

## Build ISO

### Yêu cầu

- **Arch Linux** (native) hoặc **Docker** (trên mọi OS)
- Gói: `archiso`, `make`

### Build local (Arch Linux)

```bash
make build        # Dev build (lz4, nhanh)
make release      # Release build (xz, nhỏ hơn)
make clean        # Xoá work/ và out/
```

### Build bằng Docker (mọi OS)

```bash
make docker-build       # Build dev trong Docker
make docker-release     # Build release trong Docker
```

### Make targets

| Lệnh | Mục đích |
|---|---|
| `make build` | Build dev (lz4) |
| `make release` | Build release (xz) |
| `make debug` | Debug build (verbose boot) |
| `make clean` | Xoá work/ và out/ |
| `make shell` | Vào chroot để debug |
| `make test` | Boot ISO trong QEMU (UEFI) |
| `make docker-build` | Build dev trong Docker |
| `make docker-release` | Build release trong Docker |

### Quy trình build

```
1. mkarchiso đọc profile/
2. Pacstrap packages từ packages.x86_64 (official repos + caramos-repo)
3. Copy overlay từ profile/airootfs/ vào rootfs
4. Chạy profile/airootfs/root/customize.sh (branding, services, cleanup)
5. Tạo squashfs → GRUB/syslinux/systemd-boot → ISO
```

## Version

CaramOS dùng mô hình **rolling release** — version = ngày build (YYYY.MM.DD).
Khai báo trong `profile/profiledef.sh`:
```bash
iso_version="$(date +%Y.%m.%d)"
```

## Cài đặt

1. Tải ISO từ GitHub Releases
2. Ghi ra USB: `sudo dd if=caramos-*.iso of=/dev/sdX bs=4M status=progress`
3. Boot từ USB và làm theo hướng dẫn cài đặt

## CaramOS-Repo (gói tuỳ chỉnh)

Các gói custom được build riêng tại [CaramOS-Repo](https://github.com/minhmc2007/CaramOS-Repo):

- `caramos-keyring` — PGP keyring cho pacman
- `cinnamon-delight-theme` — Theme mặc định
- `fcitx5-lotus` — Bộ gõ tiếng Việt
- `google-chrome` — Trình duyệt Chrome
- `lightdm-slick-greeter` — LightDM greeter
- `wps-office-cn` — WPS Office
- `xed`, `xreader`, `xviewer` — X-Apps từ Linux Mint
- `zalo` — Ứng dụng chat

## Đóng góp

Xem [CONTRIBUTING.md](CONTRIBUTING.md) để biết thêm chi tiết.

## Contributors

<p align="center">
  <a href="https://github.com/VN-Linux-Family/CaramOS/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=VN-Linux-Family/CaramOS" alt="CaramOS GitHub contributors">
  </a>
</p>

## Giấy phép

CaramOS là phần mềm mã nguồn mở theo giấy phép [GPL-3.0](LICENSE).

---

<p align="center">
  <strong>CaramOS</strong> — Sweet & Simple Linux<br>
  Made with love by <a href="https://vietnamlinuxfamily.net">Vietnam Linux Family</a>
</p>
