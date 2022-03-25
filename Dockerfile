FROM archlinux:base-devel

ENV USERNAME=getnative
ENV USERHOME=/home/${USERNAME}
ENV DATA_DIR=/data ENTRYFILE=${USERHOME}/entrypoint.sh

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
WORKDIR ${USERHOME}
RUN git clone https://aur.archlinux.org/paru-bin.git \
 && cd paru-bin \
 && makepkg --noconfirm -si \
 # Install dependencies from AUR and install getnative
 && paru --noconfirm -S vapoursynth-plugin-descale-git \
 && paru --noconfirm -S vapoursynth-tools-getnative-git \
 && paru --noconfirm -D --asdep git vapoursynth-plugin-descale-git

# Clean things up
USER root
RUN rm -rf ${USERHOME}/paru-bin \
 && rm -rf ${USERHOME}/.cache/ \
 && pacman --noconfirm -Rns $(pacman -Qdtq) \
 && rm -rf /var/cache/pacman/pkg/* \
 # Create entrypoint file
 && echo $'#!/usr/bin/env bash \n\
set -u \n\
rm -f ${ENTRYFILE} \n\
NEWUID=$(stat -c %u ${DATA_DIR}) \n\
NEWGID=$(stat -c %g ${DATA_DIR}) \n\
usermod -u ${NEWUID} ${USERNAME} &> /dev/null \n\
groupmod -g ${NEWGID} ${USERNAME} &> /dev/null \n\
if [ $# -eq 0 ]; then \n\
  echo "cd ${DATA_DIR} && rm -f /tmp/rcfile" > /tmp/rcfile \n\
  chown ${NEWUID}:${NEWGID} /tmp/rcfile \n\
  exec setpriv --reuid=${NEWUID} --regid=${NEWGID} --init-groups --reset-env /usr/bin/bash --rcfile /tmp/rcfile \n\
else \n\
  exec setpriv --reuid=${NEWUID} --regid=${NEWGID} --init-groups --reset-env "$@" \n\
fi' > ${ENTRYFILE} \
 && chmod +x ${ENTRYFILE}

# Entrypoint
WORKDIR ${DATA_DIR}
VOLUME ${DATA_DIR}
ENTRYPOINT ["/home/getnative/entrypoint.sh"]
