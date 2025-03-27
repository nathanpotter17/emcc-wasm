# Welcome to the WASI / Rust section of the repository!

This section of the repository contains the WebAssembly System Interface (WASI) examples, Rust examples for WASM and WASI, and documentation on build processes.

## Requirements

- emcc toolchain
  - cmake, ninja, make, gcc, g++, emcc, em++
- wasmtime or wasmer
- wat2wasm

## Optional, but recommended

- rustc, cargo, wasm-pack, wasm-bindgen, wasm32 targets

## Basic Example - C to WASI

To get started, you will need to get the ByteCode Alliance's Wasmtime runtime installed on your machine. It is the easiest to get started with, and it is the most widely used runtime for WASI. You can also use Wasmer, which is another popular runtime for WASI.

Here, we primarily use Emscripten's STANDALONE_WASM to build the WASI example, and then run it using Wasmtime or Wasmer. This allows us to run the WASI example without a browser, in a first-principles way. This is a great way to get started with WASI, and to understand how it works.

As a note, the Emscripten toolchain is not required to run the WASI example, but it is required to build the WASI example. This is because the Emscripten toolchain provides the necessary tools to build the WASI example from C to WebAssembly. You can achieve similar results by using the [wasi-sdk](https://github.com/webassembly/wasi-sdk) directly by building the toolchain & sysroot using cmake, or grab a release.

To make things easier, we will use the Emscripten toolchain to build the WASI example, and then run it using Wasmtime or Wasmer - and for Rust, we will use the latest stable Rust toolchain & `cargo component` to build WASI examples, and then run it using Wasmtime, Wasmer, or a capable host script in JS or Rust that will load and process our resulting WASM binary.

See information about using WASI [here](https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md), and on the [V8 Dev Blog](https://v8.dev/blog/emscripten-standalone-wasm).

## Building the Example

Next, you will need to build the WASI example in this repository. You can do this by running the following commands, or by altering the emcc command when build wasm to use STANDALONE_WASM=1.

`bash build.sh wasi` which will use wat2wasm to build the WASI example.

If you need a different example, here is an example command to build a simple C file for WASI:

`emcc src/wasi/c/hello.c -o src/wasi/build/demo.wasm -s STANDALONE_WASM=1`

## Running the Example

`wasmtime src/wasi/build/demo.wasm`

`wasmer run demo.wasm`

## Resources

- [WASI](https://github.com/WebAssembly/WASI?tab=readme-ov-file)
- [Wasmtime](https://wasmtime.dev/)
- [Wasmer](https://docs.wasmer.io/install)

## WASM / WASI with Rust

For getting started with Rust-based WASM, start here:

- https://wasi.dev/
- https://docs.rs/wasi/latest/wasi/index.html
- https://docs.wasmtime.dev/examples-rust-wasi.html
- https://component-model.bytecodealliance.org/language-support/rust.html
- https://component-model.bytecodealliance.org/design/wit.html
- https://rustwasm.github.io/docs/book/game-of-life/setup.html
- https://www.youtube.com/watch?v=hcA_GuZHyZM

First, we will create a simple Rust project that will compile to a WASM binary, and will load it into the web browser using JavaScript. This is the simplest way to get started with WASM / WASI and Rust, and it will help you to understand how to use WASM / WASI with Rust in a more advanced way.

Second, I've decided to use Rust and the newest preview of WASM / WASI target, Preview 2, to leverage the new features and capabilities of WASM / WASI surrounding the empowerment of WebAssembly binaries with native host capabilities.

Grab these targets from rustup:

`rustup target add wasm32-unknown-unknown wasm32-wasip1 wasm32-wasip2`

If the command fails, be sure to update your Rust toolchain to the latest version, and check available targets.

`rustup update stable`
`rustup target list`

## Building WASI CLI Apps

First, initialize using cargo:

`cargo init wasm-cla-example`

Then, use the following to collect command line arguments using the rust standard library.

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let name: String = args[1].clone();

    println!("Hello, {}", name);
}
```

Build using the wasm32-wasip1 target.

`cargo build --release --target=wasm32-wasip1`

To test, use your shell of choice:

```
cargo run anystring

Hello, anystring

wasmtime run target/wasm32-wasip1/release/wasm-cla.wasm Nathan

Hello, Nathan
```

## No Crates, just Targets (Rusty WASM)

To start, lets just get a simple WASM file generated for the wasm32-unknown-unknown target:

`cargo init --lib --name example-name`
`cd example-name`

Add the following to your Cargo.toml:

```toml
[lib]
crate-type = ["cdylib"]
```

Add the following to your src/lib.rs:

```rust
#[unsafe(no_mangle)]
fn add(a: u32, b: u32) -> u32 {
    a + b
}
```

Build the WASM binary:

`cargo build --release --target=wasm32-unknown-unknown`

Then, have a look at the example `index.html` file in the `rust` directory. You can use this file to load & run the WASM binary in the browser. Check the console for the output of the WASM binary.

Additionally, we can also use the --invoke flag with wasmtime to run the WASM binary from the command line. Note: logging is not enabled by default, so you will either need to enable logging or use the console.log function in the WASM binary to see the output. Wasmer runtime has support for this.

`wasmtime target/wasm32-unknown-unknown/release/example-name.wasm --invoke add 1 2`

## Building using wasm_bindgen & js_sys Crates

First, initialize the project & download these crates:

```
cargo install wasm-bindgen-cli

cargo init --lib wasm-bindgen-example
cd wasm-bindgen-example

cargo add js-sys
```

Add the following to your Cargo.toml:

```toml
[lib]
crate-type = ["cdylib"]
```

Edit your lib.rs:

```rust
use wasm_bindgen::prelude::*;

// structs
#[wasm_bindgen]
pub struct Facts {
    pub count: u32,
}

// internal method
#[wasm_bindgen]
pub fn test_string(s: &str) -> Facts {
    let count = s.chars().count() as u32;
    Facts { count }
}

// The utf-8 string provided is copied to the JS heap and the string will be owned by the JS garbage collector.
#[wasm_bindgen]
pub fn see_string() -> JsValue {
    let test_str = "Hello, from Rust!";
    JsValue::from_str(test_str)
}

// Call JS Methods, like Set on an Object. Return JsValue
#[wasm_bindgen]
pub fn invoke_test_string() -> JsValue {
    let test_str = "Hello, WebAssembly!";
    let facts = test_string(test_str);

    // Create a new object from inside Rust
    let js_object = js_sys::Object::new();

    // Set the 'count' property
    js_sys::Reflect::set(&js_object, &JsValue::from_str("count"), &JsValue::from_f64(facts.count as f64)).unwrap();

    // Set another property: 'message'
    let message = format!("The message is: {}", test_str);
    js_sys::Reflect::set(&js_object, &JsValue::from_str("message"), &JsValue::from_str(&message)).unwrap();

    // Set a third property: 'is_valid'
    js_sys::Reflect::set(&js_object, &JsValue::from_str("is_valid"), &JsValue::from_bool(true)).unwrap();

    // Return the object to JavaScript
    js_object.into()
}
```

Next, build for release, and compile to JS with a web target.

```
cargo build --release --target=wasm32-unknown-unknown

mkdir wasm

wasm-bindgen target/wasm32-unknown-unknown/release/wasm_prs.wasm --out-dir wasm --target web
```

Then, have a look at the example `index.html` file in the `rust` directory. Check the console for the output of the JS.

## Building using wasm-bindgen, web-sys, & js-sys Crates

To make interacting with the DOM easier, we can use the `web-sys` crate. This crate provides bindings to the Web APIs, and allows us to interact with the DOM directly from Rust.

This makes it easier to allow interactivity to take place. For this example, we'll create a simple input handling system that moves a square around the canvas.

First, initialize the project & download these crates:

```
cargo init --lib --name wasm-input-game

cargo add wasm-bindgen js-sys web-sys
```

Add the following to your Cargo.toml:

```toml
[lib]
crate-type = ["cdylib"]
```

See the `lib.rs` file under `rust/wasm-input/src` for the example code.

Find more wasm crates here: https://rustwasm.github.io/docs/book/reference/crates.html

## Building using wasm-pack & wasm-bindgen under the hood

This is one of the more fun examples, we get to implement Conway's Game of Life!

Using [wasm-pack](https://rustwasm.github.io/wasm-pack/installer/), we can orchestrate the following build steps:

- Ensure that we have Rust 1.30 or newer and the wasm32-unknown-unknown target installed via rustup.
- Compile our Rust sources into a WebAssembly .wasm binary via cargo.
- Use wasm-bindgen to generate the JavaScript API for using our Rust-generated WebAssembly.

To start, follow [this guide](https://rustwasm.github.io/docs/book/game-of-life/hello-world.html).

Once you finish the setup, progress to the "Implementing Life" section. It demonstrates how to include functions
inside a class, and how to use `wasm-pack` to build everything for you.

Have a look at the example `index.html` file in the `rust/wasm/wasm-pack` directory. Serve it using
your favorite server, and view the output on the page for a pre-built example.

## Advanced Rust-based & Language Agnostic WASM / WASI

Alternatively, [cargo component](https://crates.io/crates/cargo-component) can be used to build a WebAssembly component for use with the Component Model. You can subsequently use [wasm-tools](https://github.com/bytecodealliance/wasm-tools) to generate the .wit file for the component, validate the .wasm file, demangle Rust and C++ symbol names, and more.
