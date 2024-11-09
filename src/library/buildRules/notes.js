// EMCMAKE CMAKE COMMANDS FOR DLIB
// review compilation notes: https://github.com/davisking/dlib/blob/master/examples/CMakeLists.txt

// First clone a copy of dlib from github.

// git clone https://github.com/davisking/dlib/tree/master

// emcmake cmake -G Ninja -S ./statics/dlib -B ./statics/dlib/static_build -D BUILD_SHARED_LIBS=OFF -D CMAKE_MAKE_PROGRAM=C:/ninja-win/ninja.exe -D CMAKE_C_COMPILER=C:/Users/natha/emsdk/upstream/emscripten/emcc -D CMAKE_CXX_COMPILER=C:/Users/natha/emsdk/upstream/emscripten/em++ -D CMAKE_CXX_COMPILER=C:/msys64/ucrt64/bin/g++.exe -D CMAKE_INSTALL_PREFIX=./statics/dlib/install

// static_build dir is created automatically by cmake, so no need to create it manually.

// cd to static_build then create install dir.

// emmake ninja install

// .A FILES: static_build/install/lib/libdlib.a
// INCLUDE DIR: static_build/install/include/
