#!/bin/sh

set -e

# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
sudo apt-get remove google-chrome-stable google-cloud-cli microsoft-edge-stable
sudo apt update
sudo apt-get install ffmpeg
sudo apt-get autoremove
sudo apt-get clean

mkdir -p "$HOME/.config/yt-dlp" "$HOME/.local/bin" "output"
ln    -s "$PWD/.config/yt-dlp/config" "$HOME/.config/yt-dlp/config"
ln    -s "$PWD/cache/wgcf"            "$HOME/.local/bin/wgcf"
ln    -s "$PWD/cache/wireproxy"       "$HOME/.local/bin/wireproxy"
ln    -s "$PWD/cache/yt-dlp"          "$HOME/.local/bin/yt-dlp"

if [ ! -f "cache/wireproxy" ]; then
	curl \
		--ipv4 \
		--location \
		--create-dirs \
		--output-dir cache \
		--remote-name \
		"https://github.com/pufferffish/wireproxy/releases/latest/download/wireproxy_linux_amd64.tar.gz"
	tar   -xf "cache/wireproxy_linux_amd64.tar.gz" -C "cache"
	rm        "cache/wireproxy_linux_amd64.tar.gz"
	chmod +x  "cache/wireproxy"
fi

if [ ! -f "cache/wgcf" ]; then
	curl \
		--ipv4 \
		--location \
		--create-dirs \
		--output wgcf \
		--output-dir cache \
		--remote-name \
		"https://github.com/ViRb3/wgcf/releases/latest/download/wgcf_2.2.24_linux_amd64"
	chmod +x "cache/wgcf"
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
