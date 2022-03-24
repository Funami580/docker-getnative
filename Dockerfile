FROM archlinux:base-devel

ENV USERNAME=getnative
ENV HOME=/home/${USERNAME}

# Update packages and install git
RUN pacman --noconfirm -Syu git \
 # Add user for non-root operations
 && useradd --no-log-init -mG wheel ${USERNAME} \
 # Do not ask for password when using sudo with this newly created user
 && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
 # Install getnative dependencies from Arch repositories
 && pacman --noconfirm -S --asdep vapoursynth ffms2 ffmpeg pipewire-media-session pipewire-jack tesseract-data-eng

# Install paru as AUR helper
USER ${USERNAME}
WORKDIR ${HOME}
RUN git clone https://aur.archlinux.org/paru-bin.git \
 && cd paru-bin \
 && makepkg --noconfirm -si \
 # Install dependencies from AUR and install getnative
 && paru --noconfirm -S vapoursynth-plugin-descale-git \
 && paru --noconfirm -S vapoursynth-tools-getnative-git \
 && paru --noconfirm -D --asdep git vapoursynth-plugin-descale-git

# Clean things up
USER root
RUN rm -rf ${HOME}/paru-bin \
 && rm -rf ${HOME}/.cache/ \
 && pacman --noconfirm -Rns $(pacman -Qdtq) \
 && rm -rf /var/cache/pacman/pkg/*

# Entrypoint
ENV DATA_DIR=/data
WORKDIR ${DATA_DIR}
VOLUME ${DATA_DIR}
ENTRYPOINT ["/usr/bin/bash", "-c", "usermod -o -u $(stat -c %u ${DATA_DIR}) ${USERNAME} &> /dev/null && groupmod -o -g $(stat -c %g ${DATA_DIR}) ${USERNAME} &> /dev/null && exec sudo -u ${USERNAME} -s"]
