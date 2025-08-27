#!/bin/bash

echo "$(ps aux | grep Xtigervnc)"

Xtigervnc :1 -geometry 1280x800 -depth 24 -SecurityTypes None &
DISPLAY=:1 startxfce4 &

websockify --web=/usr/share/novnc/ 6080 localhost:5901
