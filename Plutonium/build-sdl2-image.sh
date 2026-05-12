#!/bin/bash

# SDL2_image Build Script for GNU/Linux
# Converted from PKGBUILD

set -e  # Exit immediately on error

# Configuration parameters
PKGVER="2.6.3"
URL="https://libsdl.org/projects/SDL_image/"
PKG_NAME="SDL2_image-${PKGVER}"
TARBALL="${PKG_NAME}.tar.gz"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_PREFIX="${INSTALL_PREFIX:-${SCRIPT_DIR}}"

echo "===== SDL2_image Build Script ====="
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

patch -Np1 -i ${SCRIPT_DIR}/sdl2_image.patch Makefile.in

# Configure build parameters
echo "Running configure..."
./configure --prefix="${INSTALL_PREFIX}" \
    --host=aarch64-none-elf --disable-shared --enable-static \
    --disable-sdltest \
    --disable-avif \
    --disable-tif \
    --disable-jxl

echo "Building..."
make check -j$(nproc)

# Install
make install

echo ""
echo "===== Build Complete ====="
echo "Installed to: ${INSTALL_PREFIX}"

# Clean up temporary directory
rm -rf "$WORK_DIR"
echo "Work directory (deleted): $WORK_DIR"
