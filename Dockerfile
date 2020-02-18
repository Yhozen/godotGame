FROM garox/godot-builder:3.2

ENV EXPORT_NAME HTML5
ENV OUTPUT_FILENAME index.html

ADD debug.keystore debug.keystore

CMD ["sh", "-c", "godot-headless --export \"${EXPORT_NAME}\" --path /build/src \"/build/output/${OUTPUT_FILENAME}\""]
