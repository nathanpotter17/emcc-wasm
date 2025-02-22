## Welcome to the WASI section of the repository!

This section of the repository contains the WebAssembly System Interface (WASI) examples and documentation.

### Requirements

wasmtime or wasmer

wat2wasm

### Optional

clang / cmake / emcc

### Basic Example - C to WASI

To get started, you will need to get the ByteCode Alliance's Wasmtime runtime installed on your machine.

See information about using WASI here, and on the V8 Dev Blog: https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md - https://v8.dev/blog/emscripten-standalone-wasm

Wasmtime - https://wasmtime.dev/ - Can execute WASM and WAT files.
Wasmer - https://docs.wasmer.io/install

https://docs.wasmtime.dev/examples-c-wasi.html

https://nodejs.org/api/wasi.html

### Building the Example

Next, you will need to build the WASI example in this repository. You can do this by running the following commands, or by altering the emcc command when build wasm to use STANDALONE_WASM=1.

`bash build.sh wasi` which will use wat2wasm to build the WASI example.

If you need a different example, here is an example command to build a simple C file for WASI:

`emcc src/c/hello.c -o build/demo.wasm -s PURE_WASI=1 -s EXPORT_ALL=1`

`wat2wasm src/wasm/demo.wat -o build/demo.wasm`

### Running the Example

`wasmtime ../wasm/demo.wat`

`wat2wasm src/wasm/demo.wat -o build/demo.wasm`
`wasmer run demo.wasm`
