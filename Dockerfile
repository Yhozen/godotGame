FROM m0rf30/arch-yay

RUN  yay -S --noconfirm android-sdk-platform-tools android-udev android-sdk && export ANDROID_HOME=/opt/android-sdk && export PATH=$PATH:$ANDROID_HOME/tools && export PATH=$PATH:$ANDROID_HOME/platform-tools

RUN ls

ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

USER root 
RUN echo 'Set disable_coredump false' > /etc/sudo.conf && useradd -m aurman -s /bin/bash && echo 'aurman ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER aurman
WORKDIR /home/aurman

ADD PKGBUILD PKGBUILD
RUN makepkg --noconfirm -si

USER root
RUN pacman  --noconfirm -Syu  unzip wget fakeroot sudo binutils

ARG GODOT_VERSION=3.2

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

RUN mkdir -p $XDG_CONFIG_HOME/godot

RUN echo "[gd_resource type=\"EditorSettings\" format=2]" >> $XDG_CONFIG_HOME/godot/editor_settings-3.tres \
    && echo "[resource]" >> $XDG_CONFIG_HOME/godot/editor_settings-3.tres \
    && echo "export/android/adb = \"$(which adb)\"" >> $XDG_CONFIG_HOME/godot/editor_settings-3.tres \
    && echo "export/android/jarsigner = \"$(which jarsigner)\"" >> $XDG_CONFIG_HOME/godot/editor_settings-3.tres \
    && echo "export/android/debug_keystore = \"$(pwd)/debug.keystore\"" >> $XDG_CONFIG_HOME/godot/editor_settings-3.tres
RUN ls
ADD /build/src/debug.keystore debug.keystore
RUN ls
RUN cat $XDG_CONFIG_HOME/godot/editor_settings-3.tres

RUN cat $XDG_CONFIG_HOME/godot/editor_settings-3.tres

CMD ["sh", "-c", "godot-headless --export \"${EXPORT_NAME}\" --path /build/src \"/build/output/${OUTPUT_FILENAME}\""]
