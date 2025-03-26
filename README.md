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

Serve `/index.html` using VSCode's Live Server or any other server. It contains all examples served from the build folder. Uncomment the script you want to run in the HTML file, and check the console for output.

To start from source folders, checkout `bash build.sh`.

Note: Not all scripts are included; Inspect `build.sh` - Some may be specific to your OS.

## Run Standalone WASM - Wasmer or WasmTime - WASI (WebAssembly System Interface)

See the `src/wasi` directory for more information on WASI, and using Rust with WASM / WASI.

## Advanced Usage - Build C++ Libraries for Web Usage

[Build Flow PDF](src/library/documentation/emcc.pdf)

See `src/library` for all advanced examples.

See `src/library/cmake` for documentation on compiling and including libraries.
