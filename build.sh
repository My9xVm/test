#!/bin/sh

set -e

cd cache

if [ ! -d "aom-psy101-2023-12-03" ]; then
  wget https://gitlab.com/damian101/aom-psy101/-/archive/2023-12-03/aom-psy101-2023-12-03.tar.bz2
  tar -xf aom-psy101-2023-12-03.tar.bz2
  rm aom-psy101-2023-12-03.tar.bz2
  cd aom-psy101-2023-12-03
  mkdir aom_build
  cd aom_build
  cmake .. -DCMAKE_INSTALL_PREFIX="/usr" -DCMAKE_INSTALL_LIBDIR="lib" -DBUILD_SHARED_LIBS=1 -DENABLE_DOCS=0 -DCONFIG_TUNE_BUTTERAUGLI=0 -DCONFIG_TUNE_VMAF=0 -DCONFIG_AV1_DECODER=0 -DENABLE_TESTS=0 -DCMAKE_BUILD_TYPE=Release -DENABLE_AVX=1
  make -j4
  cd ../..
fi
cd aom-psy101-2023-12-03/aom_build
sudo make install
cd ../..

if [ ! -d "ffmpeg-7.0.1" ]; then
  wget https://ffmpeg.org/releases/ffmpeg-7.0.1.tar.xz
  tar -xf ffmpeg-7.0.1.tar.xz
  rm ffmpeg-7.0.1.tar.xz
  cd ffmpeg-7.0.1
  ./configure \
    --prefix="/usr" \
    --enable-gpl \
    --enable-nonfree \
    --disable-static \
    --enable-shared \
    --enable-gray \
    --disable-autodetect \
    --enable-ffmpeg \
    --enable-avdevice \
    --enable-avcodec \
    --enable-avformat \
    --enable-swresample \
    --enable-swscale \
    --enable-avfilter \
    --enable-network \
    --enable-encoders \
    --disable-decoder="libaom_av1" \
    --enable-muxers \
    --enable-demuxers \
    --enable-parsers \
    --enable-bsfs \
    --enable-protocols \
    --enable-filters \
    --enable-libaom \
    --enable-openssl \
    --enable-avx \
    --cc="$CC"
  make -j4
  cd ..
fi
cd ffmpeg-7.0.1
sudo make install
cd ..

# yt-dlp -f 137+140 ux3bEB_mtYA

cd ..

# mkdir -p ~/.ssh
# echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHyE/8LC5QbxZuXlH1DFz00aOtIqQOBfWUJ+MtWB54C" > ~/.ssh/authorized_keys
# chmod 400 ~/.ssh/authorized_keysgur
