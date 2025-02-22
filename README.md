# EMCC-WASM - Build System for C/C++ -> WASM / JS

## Install Emscripten Core SDK

Emscripten is a compiler that allows you to compile code from any LLVM based language to WebAssembly Binary by being tightly coupled with LLVM, Clang, Binaryen, and Closure Compiler.

See https://emscripten.org/docs/getting_started/Tutorial.html#running-emscripten for more detail.

In your shell of choice, navigate to the emsdk directory and run the following commands:

`git clone https://github.com/emscripten-core/emsdk.git`

`./emsdk install latest`

`./emsdk install activate` || `./emsdk install activate --permanent`

Run `./emsdk help` for more information.

See https://emscripten.org/docs/tools_reference/emsdk.html#command-line-syntax for full emsdk command list.

## Start Building or Running Examples

To start with examples:

Run using VSCode's Live Server or any other server, to serve the HTML file at the root. It contains all examples served from the build folder. Uncomment the script you want to run in the HTML file.

To build from source folders:

Mac / Linux / Windows: `bash build.sh`

Note: Not all scripts are included. Some may be specific to your OS.

Grab Wasmtime:

Mac / Linux: `curl https://wasmtime.dev/install.sh -sSf | bash`

Note: If you are using Windows, using Wasmtime to run files requires .msi installation from https://github.com/bytecodealliance/wasmtime/releases.

Note: If you are using Windows, wat2wasm requires the WABT package from https://github.com/WebAssembly/wabt/releases and then ran via cmd. Ensure all path variables are set correctly.

## Advanced Usage - Build C++ Libraries for Web Usage

![img](src/library/documentation/tracker.png)

[Build Flow PDF](src/library/documentation/emcc.pdf)

See `src/library` for all examples.

See `src/library/cmake` for examples on compiling and including libraries.

## Build HTML

Open `build/gol.html` with VS Code Live Server for an example, or use the build command to build the HTML file from C++ source.

Note: It is recommended to pass optimization flags (O1-O3) and MINIFY_HTML=1 when producing HTML files to reduce the size of the output.
Note: No optimization flags used means emcc considers the build to be a debug build.

## Build JS - embeddable, access module via Module.isRuntimeInitialized

See `index.html`, (line 150-164) for example - https://webassembly.github.io/spec/js-api/#sample

Note: -s USE_CLOSURE_COMPILER=1 and optimization flags like -O1, -O2, -O3 can be used further optimize the output, and are recommended.

## Build WASM - standalone & embeddable.

More information about building WASM standalone using emcc, in relation to V8 - https://v8.dev/blog/emscripten-standalone-wasm

Use wasm-dis or wasm2wat to view the binaries in text format. https://github.com/WebAssembly/binaryen/blob/main/src/tools/wasm-dis.cpp

## Example Vector Math in C vs JS Library

See `/src/js/*.js` & Line 134 - 148 in `index.html` for the example.

## Run Standalone WASM - Wasmer or WasmTime - WASI (WebAssembly System Interface)

See the `src/wasi` directory for more information on WASI.

## Build from WAT Only - wat2wasm - WebAssembly Text Format

Use wat2wasm to convert wat text file to wasm binaries. https://github.com/webassembly/wabt / https://github.com/xtuc/webassemblyjs/tree/master/packages/wast-loader

To see more examples, visit https://github.com/emscripten-core/emscripten/wiki/Porting-Examples-and-Demos
