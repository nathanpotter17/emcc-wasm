#!/bin/bash

# Set paths
USER_PATH=$(cygpath -w "$USERPROFILE")
BUILDER_DIR=$(cygpath -w "$(pwd)")  # Use current directory as builder
echo "Builder directory: $BUILDER_DIR"
echo "User path: $USER_PATH"

DLIB_DIR="$BUILDER_DIR\dlib"
BUILD_DIR="$DLIB_DIR\static_build"
INSTALL_DIR="$DLIB_DIR\install"
EMSDK_PATH="$USER_PATH\emsdk\upstream\emscripten"
NINJA_PATH="C:\ninja-win\ninja.exe"

# Create necessary directories
mkdir -p "$DLIB_DIR"

# Clone dlib if it doesn't exist
if [ ! -d "$DLIB_DIR/.git" ]; then
    echo "Cloning DLib repository..."
    git clone https://github.com/davisking/dlib "$DLIB_DIR"
else
    echo "DLib directory already exists, skipping clone."
fi

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Run CMake with Emscripten
if emcmake cmake -G Ninja \
    -S "$DLIB_DIR" \
    -B "$BUILD_DIR" \
    -D BUILD_SHARED_LIBS=OFF \
    -D CMAKE_MAKE_PROGRAM="$NINJA_PATH" \
    -D CMAKE_C_COMPILER="$EMSDK_PATH\emcc" \
    -D CMAKE_CXX_COMPILER="$EMSDK_PATH\em++" \
    -D CMAKE_INSTALL_PREFIX="$INSTALL_DIR"; then
    echo "CMake configuration successful."
else
    echo "CMake configuration failed. Check paths and try again."
    exit 1
fi

# Change to build directory
if cd "$BUILD_DIR" || exit; then
    echo "Changed to build directory."
else
    echo "Failed to change to build directory."
    exit 1
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Run ninja install
emmake ninja install

# Completion message
echo "DLib successfully compiled and installed in: $INSTALL_DIR"
