#!/bin/bash

# Convert Windows paths correctly
USER_PATH=$(cygpath -w "$USERPROFILE")
BUILDER_DIR=$(cygpath -w "$(pwd)")  # Current working directory in Windows format
echo "Builder directory: $BUILDER_DIR"
echo "User path: $USER_PATH"

# Define paths
OPENCV_DIR="$BUILDER_DIR\opencv"
BUILD_DIR="$OPENCV_DIR\static_build"
INSTALL_DIR="$BUILD_DIR\install"
EMSDK_PATH="$USER_PATH\emsdk\upstream\emscripten"
NINJA_PATH="C:\ninja-win\ninja.exe"

# Create necessary directories
mkdir -p "$OPENCV_DIR"

# Clone OpenCV if it doesn't exist
if [ ! -d "$OPENCV_DIR/.git" ]; then
    echo "Cloning OpenCV repository..."
    git clone https://github.com/opencv/opencv "$OPENCV_DIR"
else
    echo "OpenCV directory already exists, skipping clone."
fi

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Run CMake with Emscripten
if emcmake cmake -G Ninja \
    -S "$OPENCV_DIR" \
    -B "$BUILD_DIR" \
    -D BUILD_SHARED_LIBS=OFF \
    -D CMAKE_C_COMPILER="$EMSDK_PATH\emcc" \
    -D CMAKE_CXX_COMPILER="$EMSDK_PATH\em++" \
    -D CMAKE_MAKE_PROGRAM="$NINJA_PATH" \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
    -D BUILD_LIST=core,imgproc,videoio \
    -D ENABLE_PIC=ON \
    -D WITH_ZLIB=ON \
    -D WITH_IPP=OFF \
    -D BUILD_ITT=OFF \
    -D BUILD_IPP_IW=OFF \
    -D WITH_ITT=OFF \
    -D WITH_PTHREADS_PF=OFF \
    -D CV_ENABLE_INTRINSICS=OFF \
    -D BUILD_WASM_INTRIN_TESTS=OFF \
    -D WITH_WEBNN=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D WITH_CUDA=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF; then
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
if emmake ninja install; then
    echo "OpenCV successfully compiled and installed in: $INSTALL_DIR"
else
    echo "Build failed. Check errors and try again."
    exit 1
fi
