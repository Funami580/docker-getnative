FROM archlinux:base-devel

# Update packages and install git
RUN pacman --noconfirm -Syu git

# Add user for non-root operations
ENV USERNAME=getnative
ENV HOME=/home/${USERNAME}
RUN useradd --no-log-init -mG wheel ${USERNAME}

# Do not ask for password when using sudo with this newly created user
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Install paru as AUR helper
USER ${USERNAME}
WORKDIR ${HOME}
RUN git clone https://aur.archlinux.org/paru-bin.git
WORKDIR paru-bin
RUN makepkg --noconfirm -si
WORKDIR ..
RUN rm -r paru-bin
USER root

# Install dependencies from Arch repositories
RUN pacman --noconfirm -S --asdep vapoursynth ffms2 ffmpeg pipewire-media-session pipewire-jack tesseract-data-eng

# Install dependencies from AUR and install getnative
USER ${USERNAME}
RUN paru --noconfirm -S vapoursynth-plugin-descale-git
RUN paru --noconfirm -S vapoursynth-tools-getnative-git
RUN paru --noconfirm -D --asdep git vapoursynth-plugin-descale-git
USER root

# Clean things up
RUN rm -rf ${HOME}/.cache/
RUN pacman --noconfirm -Rns $(pacman -Qdtq)
RUN rm -rf /var/cache/pacman/pkg/*

# Entrypoint
ENV DATA_DIR=/data
WORKDIR ${DATA_DIR}
VOLUME ${DATA_DIR}
ENTRYPOINT ["/usr/bin/bash", "-c", "usermod -o -u $(stat -c %u ${DATA_DIR}) ${USERNAME} &> /dev/null && groupmod -o -g $(stat -c %g ${DATA_DIR}) ${USERNAME} &> /dev/null && exec sudo -u ${USERNAME} -s"]
