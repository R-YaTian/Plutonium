#!/bin/bash

# SDL2_image Build Script for GNU/Linux
# Converted from PKGBUILD

set -e  # Exit immediately on error

# Configuration parameters
PKGVER="2.8.12"
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

FILE="${1:-Makefile.in}"
sed -i \
    -e '/^noinst_PROGRAMS = showimage\$(EXEEXT) showanim\$(EXEEXT)$/d' \
    -e '/^showanim_SOURCES = .*showanim\.c$/d' \
    -e '/^showanim_LDADD = libSDL2_image\.la$/d' \
    -e '/^showimage_SOURCES = .*showimage\.c$/d' \
    -e '/^showimage_LDADD = libSDL2_image\.la$/d' \
    -e '/^showanim\$(EXEEXT):/,/^$/d' \
    -e '/^showimage\$(EXEEXT):/,/^$/d' \
    "$FILE"

# Configure build parameters
echo "Running configure..."
./configure --prefix="${INSTALL_PREFIX}" \
    --host=aarch64-none-elf --disable-shared --enable-static \
    --disable-sdltest \
    --disable-avif \
    --disable-tif \
    --disable-jxl \
    --disable-imageio

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
