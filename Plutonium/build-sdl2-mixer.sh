#!/bin/bash

# SDL2_mixer Build Script for GNU/Linux
# Converted from PKGBUILD

set -e  # Exit immediately on error

# Configuration parameters
PKGVER="2.6.3"
URL="https://libsdl.org/projects/SDL_mixer/"
PKG_NAME="SDL2_mixer-${PKGVER}"
TARBALL="${PKG_NAME}.tar.gz"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_PREFIX="${INSTALL_PREFIX:-${SCRIPT_DIR}}"

# Target platform - Nintendo Switch
TARGET_HOST="aarch64-none-elf"

echo "===== SDL2_mixer Build Script ====="
echo "Version: ${PKGVER}"
echo "Install prefix: ${INSTALL_PREFIX}"
echo ""

# Create work directory
WORK_DIR=$(mktemp -d)
cd "$WORK_DIR"
echo "Working directory: $WORK_DIR"

# Download source tarball
echo "Downloading ${TARBALL}..."
if ! wget -q "${URL}release/${TARBALL}"; then
    echo "Error: Failed to download ${TARBALL}"
    exit 1
fi

# Extract tarball
echo "Extracting ${TARBALL}..."
tar xf "$TARBALL" --exclude='Xcode'

# Enter source directory
cd "$PKG_NAME"
echo "Entering directory: $PKG_NAME"

# Source development kit environment variables if available
if [ -n "$DEVKITPRO" ]; then
    echo "Sourcing DEVKITPRO environment variables..."
    source ${DEVKITPRO}/switchvars.sh
fi

# Patch Makefile.in - skip building playwave and playmus
echo "Patching Makefile.in..."
sed -i 's|\$(objects)/play.*mus\$(EXE)||' Makefile.in

# Configure build parameters
echo "Running configure..."
echo "Target platform: $TARGET_HOST"
LIBS="-lm" ./configure \
    --host="${TARGET_HOST}" \
    --prefix="${INSTALL_PREFIX}" \
    --disable-shared \
    --enable-static \
    --disable-music-cmd \
    --disable-music-mod \
    --disable-music-opus \
    --disable-music-midi

# Build
echo "Building..."
make -j$(nproc)

# Install
echo "Installing..."
make install

echo ""
echo "===== Build Complete ====="
echo "Installed to: ${INSTALL_PREFIX}"
echo "Library file: ${INSTALL_PREFIX}/lib/libSDL2_mixer.a"

# Clean up temporary directory
rm -rf "$WORK_DIR"
echo "Work directory (deleted): $WORK_DIR"
