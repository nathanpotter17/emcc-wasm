## Welcome to the WASI section of the repository!

This section of the repository contains the WebAssembly System Interface (WASI) examples and documentation.

### Requirements

emcc toolchain

wasmtime or wasmer

wat2wasm

### Optional

clang / cmake / rustc / cargo / wasm-pack / wasm-bindgen / wasm32 targets

### Basic Example - C to WASI

To get started, you will need to get the ByteCode Alliance's Wasmtime runtime installed on your machine. It is the easiest to get started with, and it is the most widely used runtime for WASI. You can also use Wasmer, which is another popular runtime for WASI.

Here, we primarily use Emscripten's STANDALONE_WASM to build the WASI example, and then run it using Wasmtime or Wasmer. This allows us to run the WASI example without a browser, in a first-principles way. This is a great way to get started with WASI, and to understand how it works.

As a note, the Emscripten toolchain is not required to run the WASI example, but it is required to build the WASI example. This is because the Emscripten toolchain provides the necessary tools to build the WASI example from C to WebAssembly. You can achieve similar results by using the [wasi-sdk](https://github.com/webassembly/wasi-sdk) directly by building the toolchain & sysroot using cmake, or grab a release. This is the WASI-enabled WebAssembly C/C++ toolchain - but this is not required for the purposes of this example.

To make things easier, we will use the Emscripten toolchain to build the WASI example, and then run it using Wasmtime or Wasmer - and for Rust, we will use the latest stable Rust toolchain & `cargo component` to build WASI examples, and then run it using Wasmtime, Wasmer, or a capable host script in JS or Rust that will load and process our resulting WASM binary.

See information about using WASI here, and on the V8 Dev Blog: https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md - https://v8.dev/blog/emscripten-standalone-wasm

[WASI](https://github.com/WebAssembly/WASI?tab=readme-ov-file)
[Wasmtime](https://wasmtime.dev/)
[Wasmer](https://docs.wasmer.io/install)

[C Examples](https://docs.wasmtime.dev/examples-c-wasi.html)

[Node.js WASI Support](https://nodejs.org/api/wasi.html)

### Building the Example

Next, you will need to build the WASI example in this repository. You can do this by running the following commands, or by altering the emcc command when build wasm to use STANDALONE_WASM=1.

`bash build.sh wasi` which will use wat2wasm to build the WASI example.

If you need a different example, here is an example command to build a simple C file for WASI:

`emcc src/wasi/c/hello.c -o src/wasi/build/demo.wasm -s STANDALONE_WASM=1`

### Running the Example

`wasmtime src/wasi/build/demo.wasm`

`wasmer run demo.wasm`

## WASI with Rust

Start here:

- https://wasi.dev/
- https://docs.rs/wasi/latest/wasi/index.html
- https://component-model.bytecodealliance.org/language-support/rust.html

- https://component-model.bytecodealliance.org/design/wit.html
- https://component-model.bytecodealliance.org/language-support/rust.html
- https://rustwasm.github.io/docs/book/game-of-life/setup.html

This is a great resource for getting started with WASI and Rust. It will help you to understand how to use WASI with Rust, and how to build and run a simple WASI application, and subsequently, how to use WASI with Rust in a more advanced way.

To take this example a step further, I've decided to use Rust and the newest preview of WASI, Preview 2, to leverage the new features and capabilities of WASI surrounding the empowerment of WebAssembly binaries with native host capabilities.

Grab the experimental target here, or use `rustup target add wasm32-wasip2`:
https://doc.rust-lang.org/rustc/platform-support/wasm32-wasip2.html

### Building WASI Projects

We can use [wasm-pack](https://rustwasm.github.io/wasm-pack/installer/) to orchestrate the following build steps:

- Ensure that we have Rust 1.30 or newer and the wasm32-unknown-unknown target installed via rustup.
- Compile our Rust sources into a WebAssembly .wasm binary via cargo.
- Use wasm-bindgen to generate the JavaScript API for using our Rust-generated WebAssembly.

Alternatively, [cargo component](https://crates.io/crates/cargo-component) can be used to build a WebAssembly component for use with the Component Model. You can subsequently use [wasm-tools](https://github.com/bytecodealliance/wasm-tools) to generate the .wit file for the component, validate the .wasm file, demangle Rust and C++ symbol names, and more.
