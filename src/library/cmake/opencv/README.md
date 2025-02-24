# OpenCV for WASM Static Build Instructions

This guide outlines the steps for building OpenCV using MSYS2's UCRT64 or Git Bash's built-in MINGW64, Ninja, and Emscripten. It covers shell environments, necessary tools, and configuration commands. It also provides common build options and troubleshooting tips.

The Emscripten pre-built static library for OpenCV and all its includes can be found in this directory, under `wasm-lib`.

All the build artifacts are located in the `OCVEMC/***/static_build` directory.

If you would like to build from source, use the builder script at `builder/build-ocv.sh`, or read the information below.

## Shell Environments for Windows

1. **MINGW64 Shell**:

   - Use for builds with Ninja and CMake. Preferable for Emscripten builds.
   - Works well using commands that have full paths.

2. **MSYS2 Shell**:
   - Found at `C:/msys64/msys2.exe`
   - `PATH` inherits from Windows environment variables; adjust paths accordingly.
   - Compilers are located in `C:/msys64/ucrt64/bin`
   - Download and manage all pacman packages for cmake, emsdk, python etc; https://packages.msys2.org/queue
   - Config files for all shells are located in the root of `C:/msys64`.
   - More of preference than necessity. See [This StackOverflow Post](https://stackoverflow.com/questions/67273235/using-ninja-as-a-generator-with-msys2-mingw-on-windows-10-x64) for more information.

## Build Commands

### Using MSYS2's UCRT64 or MINGW64 Shell, or any other shell with Emscripten and Ninja installed.

- Run this command for core, imgproc, and videoio modules:
  `emcmake cmake -G Ninja -S ./statics/opencv -B ./statics/opencv/static_build -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_COMPILER=.emsdk/upstream/emscripten/emcc -DCMAKE_CXX_COMPILER=.emsdk/upstream/emscripten/em++ -DCMAKE_MAKE_PROGRAM=C:/ninja-win/ninja.exe -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./statics/opencv/static_build/install -DBUILD_SHARED_LIBS=OFF -DBUILD_LIST=core,imgproc,videoio -DENABLE_PIC=ON -DWITH_ZLIB=ON -DWITH_IPP=OFF -DBUILD_ITT=OFF -DBUILD_IPP_IW=OFF -DWITH_ITT=OFF -DWITH_PTHREADS_PF=OFF -DCV_ENABLE_INTRINSICS=OFF -DBUILD_WASM_INTRIN_TESTS=OFF -DWITH_WEBNN=OFF -DBUILD_EXAMPLES=OFF -DWITH_CUDA=OFF -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF`

- Or, Run this command for core and imgproc modules only:
  `emcmake cmake -G Ninja -S opencv -B opencv/static_build -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_COMPILER=.emsdk/upstream/emscripten/emcc -DCMAKE_CXX_COMPILER=.emsdk/upstream/emscripten/em++ -DCMAKE_MAKE_PROGRAM=C:/ninja-win/ninja.exe -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./statics/opencv/static_build/install -DBUILD_SHARED_LIBS=OFF -DBUILD_LIST=core,imgproc -DENABLE_PIC=ON -DWITH_ZLIB=ON -DWITH_IPP=OFF -DBUILD_ITT=OFF -DBUILD_IPP_IW=OFF -DWITH_ITT=OFF -DWITH_PTHREADS_PF=OFF`

- Run:
  `emmake ninja install`
  Emscripten Configuration

## Manage Emscripten SDK (emsdk):

### Note: Emscripten 2.0.10 is verified for OpenCV, However, it is recommended to use the latest version.

emcc / em++ for compilation.
emmake for make processes.
emcmake for CMake configurations.

```
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh
Available Tools:
```

### SIMD Optimization:

Supported SIMD Operations: https://emscripten.org/docs/porting/simd.html
https://emscripten.org/docs/porting/simd.html#compiling-simd-code-targeting-x86-sse-instruction-sets
Compile existing SIMD code that uses the x86 SSE, SSE2, SSE3, SSSE3, SSE4.1, SSE4.2 or AVX intrinsics (#include <\*mmintrin.h>)

### Disable SIMD for compatibility:

WASM SIMD is not supported in all browsers. To disable SIMD, use the flags below these warning messages.

The warning messages are for deprecated SIMD operations, and could be repaired in future versions of OpenCV.

As of OpenCV 4.5.3, SIMD is deprecated and may cause warnings. To disable SIMD, use the flags above. For tracking this issue, see [My Post on StackOverflow](https://stackoverflow.com/questions/79192944/build-opencvs-core-imgproc-using-emscripten-cmake/).

```
opencv/modules/core/include\opencv2/core/hal/intrin_wasm.hpp:2088:18: warning: 'wasm_v8x16_shuffle' is deprecated: use 'wasm_i8x16_shuffle' instead [-W#pragma-messages]
 2088 |     v128_t t10 = wasm_v8x16_shuffle(t00, t01, 0,1,2,3,12,13,14,15,24,25,26,27,4,5,6,7);
      |                  ^

opencv/modules/core/include\opencv2/core/haintrin_wasm.hpp:2728:22: warning: 'wasm_v8x16_shuffle' is deprecated: use asm_i8x16_shuffle' instead [-W#pragma-messages]
 2728 |     return v_int16x8(wasm_v8x16_shuffle(vec.val, vec.val, 0,1,2,3,5,8,9,10,11,12,13,14,15,6,7));
      |                      ^
emsdk\upstream\lib\clang\20\include\wasm_simd128.h:1746:3: te: expanded from macro 'wasm_v8x16_shuffle'
 1746 |   __DEPRECATED_WASM_MACRO("wasm_v8x16_shuffle", "wasm_i8x16_shuffl)          \
      |   ^
emsdk\upstream\lib\clang\20\include\wasm_simd128.h:1687:3: te: expanded from macro '__DEPRECATED_WASM_MACRO'
 1687 |   _Pragma(__WASM_STR(GCC warning(                                            \
      |   ^
<scratch space>:3:6: note: expanded from here
    3 |  GCC warning( "'" "wasm_v8x16_shuffle" "' is deprecated: use '" "wm_i8x16_shuffle" "' instead")
      |      ^
```

### Flags to disable SIMD:

```
-DCV_ENABLE_INTRINSICS=OFF
-DBUILD_WASM_INTRIN_TESTS=OFF
-DWITH_WEBNN=OFF
```

## Common Build Options:

There are three kinds of options used to control dependencies of the library, they have different prefixes:

Options starting with WITH* enable or disable a dependency \
Options starting with BUILD* enable or disable building and using 3rdparty library bundled with OpenCV \
Options starting with HAVE\_ indicate that dependency have been enabled, can be used to manually enable a dependency if automatic detection can not be used. \

Full list of cmake options: https://docs.opencv.org/4.x/db/d05/tutorial_config_reference.html

### Ideal options for static web builds:

```
-DBUILD_SHARED_LIBS=OFF
-DBUILD_EXAMPLES=OFF
-DBUILD_TESTS=OFF
-DBUILD_PERF_TESTS=OFF
-DWITH_CUDA=OFF
-DWITH_IPP=OFF

-DBUILD_WASM_INTRIN_TESTS=OFF
-DCV_ENABLE_INTRINSICS=OFF
```

#### Include specific modules and their dependencies:

`-DBUILD_LIST=core,imgproc,videoio`

## OpenCV.js

This is a guide to build OpenCV.js with Emscripten. It is based on the official tutorial and build script, which
don't work well in some cases. Use this as reference to build OpenCV in the way you want.

To find an official pre-built version of OpenCV.js, visit: https://docs.opencv.org/4.10.0/opencv.js

See the official page: https://docs.opencv.org/4.x/d4/da1/tutorial_js_setup.html

## References:

[OpenCV Github](https://github.com/opencv/opencv/tree/4.x)
[OpenCV CMake Options](https://docs.opencv.org/4.x/db/d05/tutorial_config_reference.html)\
[Emscripten SIMD Guide](https://emscripten.org/docs/porting/simd.html)\
[Emscripten OpenCV.js Setup](https://docs.opencv.org/4.x/d4/da1/tutorial_js_setup.html)
