#!/bin/bash
# install.sh - install tvplay and its dependencies system-wide (Debian/Ubuntu)
# Usage: sudo ./install.sh [--with-mpv-conf]
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Run with sudo: sudo ./install.sh" >&2
  exit 1
fi

HERE="$(cd "$(dirname "$0")" && pwd)"

echo "==> Installing packages: mpv socat"
apt-get update -qq
apt-get install -y mpv socat

echo "==> Installing yt-dlp (official binary) to /usr/local/bin"
if [ -x /usr/local/bin/yt-dlp ]; then
  /usr/local/bin/yt-dlp -U || true
else
  if command -v wget >/dev/null; then
    wget -qO /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
  else
    curl -fsSL -o /usr/local/bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
  fi
  chmod a+rx /usr/local/bin/yt-dlp
fi

echo "==> Installing tvplay to /usr/local/bin/tvplay"
install -m 755 "$HERE/tvplay" /usr/local/bin/tvplay

if [ "${1:-}" = "--with-mpv-conf" ]; then
  echo "==> Writing system-wide mpv defaults to /etc/mpv/mpv.conf"
  mkdir -p /etc/mpv
  if [ -f /etc/mpv/mpv.conf ] && ! grep -q "tvplay" /etc/mpv/mpv.conf; then
    cp /etc/mpv/mpv.conf /etc/mpv/mpv.conf.bak
    echo "    (backed up existing file to /etc/mpv/mpv.conf.bak)"
  fi
  cat "$HERE/examples/mpv.conf" >> /etc/mpv/mpv.conf
fi

bash -n /usr/local/bin/tvplay && echo "==> Done. Try: tvplay \"https://www.youtube.com/watch?v=jNQXAC9IVRw\""
