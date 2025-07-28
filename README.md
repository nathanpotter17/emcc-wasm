# EMCC-WASM: WebAssembly and WASI using C++ & Rust

## Getting Started

Emscripten is a compiler that allows you to compile code from any LLVM based language to WebAssembly Binary by being tightly coupled with LLVM, Clang, Binaryen, and Closure Compiler.

Follow [this guide](https://emscripten.org/docs/getting_started/Tutorial.html#running-emscripten) to get started with Emscripten.

See [this list](https://emscripten.org/docs/tools_reference/emsdk.html#command-line-syntax) for `emsdk` command documentation.

## Tool Requirements

- [emcc toolchain](https://emscripten.org/docs/getting_started/downloads.html#sdk-download-and-install)
  - cmake, ninja, make, gcc, g++, emcc, em++ (use MINGW64 or MSYS2 on Windows)
- [wasmtime](https://wasmtime.dev/) and / or [wasmer](https://docs.wasmer.io/install)
- [wat2wasm](https://github.com/WebAssembly/wabt/releases)

### Optional, but recommended

- rustc, cargo, wasm-pack, wasm-bindgen, wasm32 targets (optional, but recommended)

## Prebuilt Examples

Serve `/index.html` using VSCode's Live Server or any other server. It contains all examples served from the build folder. Uncomment the script you want to run in [the HTML file](./index.html), and check the console for output.

To start from source folders, checkout `bash build.sh`.

Note: Not all scripts are included; Inspect [build.sh](./build.sh) - Some may be specific to your OS.

## Standalone WASM or WASI using Rust or C

See the [src/wasi README](src/wasi/README.md) for more information on WASI, and using Rust with WASM / WASI.

## Advanced Usage - Build C++ Libraries for Web Usage

[Advanced Build Flow PDF - Frame Processing / Image Manipulation](src/library/documentation/emcc.pdf)

- [Image Processing](src/library/htmlTestOpenCV/ocv.cpp)
- [Eye Tracking / Frame Processing](src/library/frameProcessing/trackImproved.cpp)
- [Face Detection](src/library/htmlTestDlib/test.cpp)

See `src/library/cmake` for documentation on compiling and including libraries.

See [src/library](src/library/README.md) for all advanced examples.

## Advanced Usage Part 2 - Graphics and Compute via wgpu

See my repository for a collection of [advanced examples](https://github.com/nathanpotter17/wgpu-computing/tree/main)
