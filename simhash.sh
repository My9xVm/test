#!/bin/sh
echo "$(simhash "$1" 2>&1 |tr -d '\n' | xxd -p | tr -d '\n')" "$1"
