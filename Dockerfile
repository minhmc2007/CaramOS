FROM archlinux:latest

RUN pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
        archiso \
        make \
        sudo \
        git \
        dosfstools \
        mtools \
        squashfs-tools \
        xorriso \
        libisoburn \
        grub \
        syslinux \
        mkinitcpio-archiso \
        && pacman -Scc --noconfirm

WORKDIR /app
