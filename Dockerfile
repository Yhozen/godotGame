FROM archlinux

ARG GODOT_VERSION=3.2

RUN pacman  --noconfirm -Syu  unzip wget fakeroot sudo binutils

# create user and set sudo priv
RUN echo 'Set disable_coredump false' > /etc/sudo.conf && useradd -m aurman -s /bin/bash && echo 'aurman ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# switch user and workdir
USER aurman
WORKDIR /home/aurman

ADD PKGBUILD PKGBUILD
RUN makepkg --noconfirm -si

USER root

RUN wget -q --waitretry=1 --retry-connrefused -T 10 https://downloads.tuxfamily.org/godotengine/$GODOT_VERSION/Godot_v$GODOT_VERSION-stable_export_templates.tpz -O /tmp/export-templates.tpz \
    && mkdir -p /tmp/data/godot/templates \
    && unzip -q -d /tmp/data/godot/templates /tmp/export-templates.tpz \
    && mv /tmp/data/godot/templates/templates /tmp/data/godot/templates/$GODOT_VERSION.stable

ENV XDG_CACHE_HOME /tmp/cache
ENV XDG_DATA_HOME /tmp/data
ENV XDG_CONFIG_HOME /tmp/config
RUN mkdir -p /tmp/cache && mkdir -p /tmp/data && mkdir -p /tmp/config

ENV EXPORT_NAME HTML5
ENV OUTPUT_FILENAME index.html

WORKDIR /build

CMD ["sh", "-c", "godot-headless --export \"${EXPORT_NAME}\" --path /build/src \"/build/output/${OUTPUT_FILENAME}\""]
