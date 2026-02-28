FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    firefox \
    xvfb \
    x11vnc \
    fluxbox \
    novnc \
    websockify \
    wget \
    curl \
    net-tools \
    python3 \
    && rm -rf /var/lib/apt/lists/*

ENV DISPLAY=:1
ENV VNC_PASSWORD=Rezaimuh00@

RUN mkdir -p /opt/novnc/utils/websockify && \
    ln -s /usr/share/novnc /opt/novnc && \
    ln -s /usr/bin/websockify /opt/novnc/utils/websockify/websockify

RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd Rezaimuh00@ ~/.vnc/passwd

RUN echo '#!/bin/bash\n\
echo "Starting Xvfb..."\n\
Xvfb :1 -screen 0 1280x720x24 &\n\
sleep 2\n\
\n\
echo "Starting window manager..."\n\
fluxbox &\n\
sleep 1\n\
\n\
echo "Starting VNC server..."\n\
x11vnc -display :1 -forever -usepw -rfbport 5900 &\n\
sleep 2\n\
\n\
echo "Starting noVNC web server on port 8080..."\n\
websockify --web=/usr/share/novnc --cert=none --ssl-only=false 8080 localhost:5900 &\n\
\n\
sleep 2\n\
echo "Starting Firefox..."\n\
firefox --safe-mode\n\
' > /start.sh && chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
