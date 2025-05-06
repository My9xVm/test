#!/bin/bash

zstar() {
  find "$1" ! -type d -print0 | xargs -0 -I{} ./simhash.sh "{}" | LC_ALL=C sort | cut -d' ' -f2- | tar --create --group=0 --mtime="@0" --numeric-owner --owner=0 --sort=none --file=- --format=ustar --no-recursion --files-from=- | zstd -T0 --zstd=strat=9,wlog=27,hlog=27,clog=27,slog=9,mml=3,tlen=999 -o "$1.tar.zst" -
}

zstar "$@"
