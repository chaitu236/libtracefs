#!/bin/bash

set -e

PREFIX=${PREFIX:-/tmp/emscripten_root}
HOST_INCLUDE=${HOST_INCLUDE:-/usr/include}
HOST_ARCH_INCLUDE=${HOST_ARCH_INCLUDE:-"$HOST_INCLUDE/$(gcc -print-multiarch)"}
UAPI_INCLUDES="-idirafter $HOST_INCLUDE -idirafter $HOST_ARCH_INCLUDE"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/usr/share/pkgconfig"
PKG_CONFIG="env PKG_CONFIG_PATH=$PKG_CONFIG_PATH pkg-config"
export EMCC_CFLAGS="${EMCC_CFLAGS:+$EMCC_CFLAGS }-pthread"

emmake make clean
emmake make prefix="$PREFIX" pkgconfig_dir="$PREFIX/usr/share/pkgconfig" \
	PKG_CONFIG="$PKG_CONFIG" CONFIG_INCLUDES="$UAPI_INCLUDES" \
	WASM=1 NO_PERF=1
emmake make prefix="$PREFIX" pkgconfig_dir="$PREFIX/usr/share/pkgconfig" \
	PKG_CONFIG="$PKG_CONFIG" CONFIG_INCLUDES="$UAPI_INCLUDES" \
	WASM=1 NO_PERF=1 install
