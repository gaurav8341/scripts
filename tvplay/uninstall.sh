#!/bin/bash
# uninstall.sh - remove tvplay (leaves mpv, socat and yt-dlp installed)
set -eu
if [ "$(id -u)" -ne 0 ]; then
  echo "Run with sudo: sudo ./uninstall.sh" >&2
  exit 1
fi
rm -f /usr/local/bin/tvplay
echo "Removed /usr/local/bin/tvplay."
echo "To also remove yt-dlp: sudo rm /usr/local/bin/yt-dlp"
echo "If you used --with-mpv-conf, edit /etc/mpv/mpv.conf to remove the tvplay block."
