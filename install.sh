#!/bin/sh

set -e

sudo apt update
sudo apt install ffmpeg

mkdir -p "$HOME/.config/yt-dlp" "$HOME/.local/bin" "output"
ln -s "$PWD/cache/yt-dlp"          "$HOME/.local/bin/yt-dlp"
ln -s "$PWD/.config/yt-dlp/config" "$HOME/.config/yt-dlp/config"

if [ ! -f "cache/yt-dlp" ]; then
  curl \
    --ipv4 \
    --location \
    --create-dirs \
    --output-dir cache \
    --remote-name \
    "https://github.com/yt-dlp/yt-dlp/releases/download/2024.03.10/yt-dlp"
  chmod +x "cache/yt-dlp"
fi
