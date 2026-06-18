<p align="center">
  <img src="assets/CaramOS_logo.png" alt="CaramOS Logo" width="250">
</p>

<h1 align="center">CaramOS</h1>

<p align="center">
  <strong>Sweet & Simple Linux — A Linux distro made for Vietnamese users</strong>
</p>

<p align="center">
  <em>Caram = Carambola — the starfruit, whose 5 points mirror the star on Vietnam's flag</em>
</p>

<p align="center">
  <a href="README.md">Tiếng Việt</a> · <a href="https://vietnamlinuxfamily.net">VNLF</a> · <a href="https://caramos.vietnamlinuxfamily.net">Website</a>
</p>

---

## What is CaramOS?

**CaramOS** is a Linux distribution based on **Arch Linux** with the **Cinnamon** desktop,
designed specifically for **Vietnamese users**.
It uses **mkarchiso** to build the ISO directly from Arch Linux packages.

## Key Features

| Feature | Description |
|---|---|
| **Arch Linux base** | Rolling release, always up-to-date, AUR access |
| **CaramOS branding** | Custom boot menu, Plymouth, theme, wallpapers, icons |
| **Vietnamese-first** | Vietnamese locale by default, fcitx5-lotus input method |
| **Google Chrome** | Pre-installed browser |
| **WPS Office** | Familiar office suite for users switching from Windows |
| **Zalo** | Pre-installed Vietnamese messaging app |
| **Cinnamon Delight + Tela/Bibata** | Modern, lightweight theme, icons & cursor |
| **Flexible build** | Fast dev build (lz4), smaller release build (xz), Docker support |

## Tech Stack

| Component | Technology |
|---|---|
| **Base** | Arch Linux (rolling) |
| **Desktop** | Cinnamon |
| **Display manager** | LightDM + Slick Greeter |
| **Build method** | mkarchiso |
| **Theme** | Cinnamon Delight |
| **Icons** | Tela Circle |
| **Cursor** | Bibata |
| **Input method** | Fcitx5 + Lotus |
| **Browser** | Google Chrome |
| **Office** | WPS Office |

## Build ISO

### Requirements

- **Arch Linux** (native) or **Docker** (any OS)
- Packages: `archiso`, `make`

### Native build (Arch Linux)

```bash
make build        # Dev build (lz4, fast)
make release      # Release build (xz, smaller)
```

### Docker build (any OS)

```bash
make docker-build       # Dev build in Docker
make docker-release     # Release build in Docker
```

## Contributing

See [CONTRIBUTING_EN.md](CONTRIBUTING_EN.md) for guidelines.

## License

CaramOS is open-source software licensed under [GPL-3.0](LICENSE).

---

<p align="center">
  <strong>CaramOS</strong> — Sweet & Simple Linux<br>
  Made with love by <a href="https://vietnamlinuxfamily.net">Vietnam Linux Family</a>
</p>
