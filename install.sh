#!/bin/sh

set -e

export ARCH="$(uname -m)"
export CMAKE_GENERATOR="Ninja"
export CMAKE_INSTALL_PREFIX="/usr"
export CFLAGS="-pipe -O3 -ffunction-sections -fdata-sections -fuse-ld=bfd -march=native -mtune=native"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-Wl,-O3,--strip-all,--as-needed,--gc-sections,--sort-common,--hash-style=gnu,--build-id=none"

if [ "$ARCH" = x86_64 ]; then
	# dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -n 100
	sudo apt-get remove google-chrome-stable google-cloud-cli microsoft-edge-stable > /dev/null
fi
sudo apt-get update > /dev/null
sudo apt-get install age libbrotli-dev libhwy-dev liblcms2-dev nasm ninja-build simhash  > /dev/null
# sudo apt-get install ffmpeg > /dev/null
sudo apt-get remove libaom3 > /dev/null
sudo apt-get autoremove > /dev/null
sudo apt-get clean > /dev/null

if false; then

	mkdir build
	cd build

	wget https://gitlab.com/damian101/aom-psy101/-/archive/v3.12.0/aom-psy101-v3.12.0.tar.gz
	tar -xf aom-psy101-v3.12.0.tar.gz
	rm aom-psy101-v3.12.0.tar.gz
	cd aom-psy101-v3.12.0
	mkdir aom_build
	cd aom_build
	cmake .. \
		-D CMAKE_INSTALL_LIBDIR=lib \
		-D BUILD_SHARED_LIBS=1 \
		-D ENABLE_DOCS=0 \
		-D CONFIG_AV1_DECODER=0 \
		-D ENABLE_TESTS=0
	ninja
	sudo ninja install
	cd ../../

	wget https://github.com/FFmpeg/FFmpeg/archive/n7.1.tar.gz
	tar -xf n7.1.tar.gz
	rm n7.1.tar.gz
	cd FFmpeg-n7.1
	./configure \
		--prefix=/usr \
		--enable-gpl \
		--enable-nonfree \
		--disable-static \
		--enable-shared \
		--enable-gray \
		--disable-all \
		--disable-autodetect \
		--enable-ffmpeg \
		--enable-avdevice \
		--enable-avcodec \
		--enable-avformat \
		--enable-swresample \
		--enable-swscale \
		--enable-avfilter \
		--enable-encoder="libaom_av1" \
		--enable-decoder="flac,h264,pcm_s16le,rawvideo" \
		--enable-muxer="matroska,mp4" \
		--enable-demuxer="flac,matroska,mov,wav,yuv4mpegpipe" \
		--enable-protocol="file" \
		--enable-filter="aresample,fps,scale,crop" \
		--enable-libaom \
		--enable-asm \
		--enable-sse \
		--enable-sse2 \
		--enable-sse3 \
		--enable-ssse3 \
		--enable-sse4 \
		--enable-sse42 \
		--enable-avx \
		--enable-avx2 \
		--enable-avx512 \
		--enable-avx512icl \
		--enable-aesni \
		--enable-vfp \
		--enable-neon \
		--enable-dotprod \
		--enable-i8mm \
		--enable-inline-asm \
		`# --enable-x86asm` \
		--enable-fast-unaligned \
		--enable-optimizations
	make -j4
	sudo make install
	cd ../

	cd ../

else

	echo sudo apt-get install ffmpeg  > /dev/null

fi

mkdir -p "$HOME/.config/yt-dlp" "$HOME/.local/bin" "output"
ln    -s "$PWD/.config/yt-dlp/config" "$HOME/.config/yt-dlp/config"
ln    -s "$PWD/cache/wgcf"            "$HOME/.local/bin/wgcf"
ln    -s "$PWD/cache/wireproxy"       "$HOME/.local/bin/wireproxy"
ln    -s "$PWD/cache/yt-dlp"          "$HOME/.local/bin/yt-dlp"

func_curl() {
	curl \
		--ipv4 \
		--location \
		--create-dirs \
		--output-dir cache \
		$@
}

if [ "$ARCH" = x86_64 ]; then
	if [ ! -f "cache/wireproxy" ]; then
		func_curl --remote-name "https://github.com/pufferffish/wireproxy/releases/latest/download/wireproxy_linux_amd64.tar.gz"
		tar   -xf "cache/wireproxy_linux_amd64.tar.gz" -C "cache"
		rm        "cache/wireproxy_linux_amd64.tar.gz"
		chmod +x  "cache/wireproxy"
	fi
	if [ ! -f "cache/wgcf" ]; then
		func_curl --output wgcf "https://github.com/ViRb3/wgcf/releases/download/v2.2.25/wgcf_2.2.25_linux_amd64"
		chmod +x "cache/wgcf"
	fi
	if [ ! -f "cache/yt-dlp" ]; then
		func_curl --output yt-dlp "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux"
		chmod +x "cache/yt-dlp"
	fi
else
	if [ ! -f "cache/wireproxy" ]; then
		func_curl --remote-name "https://github.com/pufferffish/wireproxy/releases/latest/download/wireproxy_linux_arm64.tar.gz"
		tar   -xf "cache/wireproxy_linux_arm64.tar.gz" -C "cache"
		rm        "cache/wireproxy_linux_arm64.tar.gz"
		chmod +x  "cache/wireproxy"
	fi
	if [ ! -f "cache/wgcf" ]; then
		func_curl --output wgcf "https://github.com/ViRb3/wgcf/releases/download/v2.2.25/wgcf_2.2.25_linux_arm64"
		chmod +x "cache/wgcf"
	fi
	if [ ! -f "cache/yt-dlp" ]; then
		func_curl --output yt-dlp "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux_aarch64"
		chmod +x "cache/yt-dlp"
	fi
fi

sudo e4defrag cache > /dev/null
