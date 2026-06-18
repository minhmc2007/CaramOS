# Contributing Guide — CaramOS

> [Tiếng Việt](CONTRIBUTING.md) · [README](README_EN.md)

---

## Project Architecture

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
1. mkarchiso reads profile/
2. Pacstrap packages from packages.x86_64 (official repos + caramos-repo)
3. Copy overlay from profile/airootfs/ into rootfs
4. Run profile/airootfs/root/customize.sh (branding, services, cleanup)
5. Create squashfs → GRUB/syslinux/systemd-boot → ISO
```

## Build ISO

### Requirements

- **Arch Linux** (native) or **Docker** (any OS)
- Packages: `archiso`, `make`

### Native build

```bash
make build        # Dev build (lz4, fast)
make release      # Release build (xz, smaller)
make clean        # Remove work/ and out/
make shell        # Enter chroot for debugging
make test         # Boot ISO in QEMU
```

### Docker build

```bash
make docker-build       # Dev build in Docker
make docker-release     # Release build in Docker
```

## How to Contribute

### You can help with

| Role | Tasks |
|---|---|
| **Tester** | Test ISO on different hardware, report bugs |
| **Designer** | Wallpapers, icons, themes, branding |
| **Developer** | PKGBUILDs, customize.sh, configs |
| **Writer** | Documentation, translations |

### Contribution Workflow

1. Fork → Clone → Branch → Commit → Push → Pull Request

### Pull Request Rules

- 1 PR = 1 feature or 1 bug fix
- Clearly describe what and why
- Test before creating PR

## Quick Reference

| Task | Location | Action |
|---|---|---|
| Add package | `profile/packages.x86_64` | Edit file, rebuild |
| Edit system config | `profile/airootfs/etc/` | Edit, rebuild |
| Edit theme/icons | `profile/airootfs/usr/share/` | Edit, rebuild |
| Edit customize script | `profile/airootfs/root/customize.sh` | Edit, rebuild |
| Edit boot config | `profile/syslinux/`, `profile/grub/` | Edit, rebuild |
| Add branding asset | `assets/` → copy to `profile/airootfs/` | Copy + rebuild |

## Code Standards

### Commit Messages — Conventional Commits

```
feat:     new feature
fix:      bug fix
docs:     documentation
chore:    build, config
brand:    wallpaper, logo, theme
```

---
