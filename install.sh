#!/bin/sh

set -e

# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
sudo apt-get remove '^google-.*' '^microsoft-.*'
sudo apt update
sudo apt install gcc libtool-bin meson nasm
sudo apt-get autoremove
sudo apt-get clean

pip3 install cython

mkdir -p "$HOME/.config/yt-dlp" "$HOME/.local/bin" "output"
ln    -s "$PWD/.config/yt-dlp/config" "$HOME/.config/yt-dlp/config"
ln    -s "$PWD/cache/av1an"           "$HOME/.local/bin/av1an"
ln    -s "$PWD/cache/cloudflared"     "$HOME/.local/bin/cloudflared"
ln    -s "cython"                     "$HOME/.local/bin/cython3"
ln    -s "$PWD/cache/yt-dlp"          "$HOME/.local/bin/yt-dlp"

(
  if [ ! -f "cache/cloudflared" ]; then
    curl \
      --ipv4 \
      --location \
      --create-dirs \
      --output-dir cache \
      --output cloudflared \
      --remote-name \
      "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"
    chmod +x "cache/cloudflared"
  fi

  if [ ! -f "cache/yt-dlp" ]; then
    curl \
      --ipv4 \
      --location \
      --create-dirs \
      --output-dir cache \
      --remote-name \
      "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"
    chmod +x "cache/yt-dlp"
  fi
) &

wait
