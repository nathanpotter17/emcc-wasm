#!/bin/bash
# This script is used to build the Rust project for Windows using MSVC.

confirm_execution() {
    while true; do
        echo -n "Proceed with this option? [Y/n]: "
        read -r confirm
        case "$confirm" in
            [Yy]) return 0 ;;  # Proceed
            [Nn]) echo "Cancelled."; exit 0 ;;  # Exit
            *) echo "Invalid input. Please enter y or n." ;;
        esac
    done
}

wipe_build() {
    if [ -d "target" ]; then
        echo -e "Cleaning previous build...\n"
        rm -rf target
    fi

    if [ -d "wasm" ]; then
        echo -e "Cleaning previous Wasm Bindgen build...\n"
        rm -rf wasm
    fi

    if [ -d "pkg" ]; then
        echo -e "Cleaning previous Wasm Pack build...\n"
        rm -rf pkg
    fi
}

check_installed() {
    if ! command cargo --version &> /dev/null; then
        echo -e "\nCargo is not installed.\n"
        echo -e "Please install Rust and Cargo from https://rustup.rs/"
        exit 1
    else
        echo -e "\nUsing Cargo: $(cargo --version)"
    fi

    if ! command rustc --version &> /dev/null; then
        echo -e "\nRustup is not installed.\n"
        echo -e "Please install Rustup from https://rustup.rs/ for toolchain management.\n"
        exit 1
    else
        echo -e "Using Rust Compiler: $(rustc --version)\n"
    fi
}

check_msvc_target() {
    if ! rustup target list --installed | grep -q "x86_64-pc-windows-msvc"; then
        echo -e "\nMSVC target not found.\n"
        echo -e "Run: rustup target add x86_64-pc-windows-msvc"
        exit 1
    fi
}

check_wasm_target() {
    if ! rustup target list --installed | grep -q "wasm32-unknown-unknown"; then
        echo -e "\nWebAssembly target not found.\n"
        echo -e "Run: rustup target add wasm32-unknown-unknown"
        exit 1
    fi
}

check_installed

echo -e "Choose build target: msvc (1) or wasm (2)?"
read choice

echo -e "Wipe previous build artifacts? [Y/n]: \n"
read wipe_choice

confirm_execution

if [[ "$wipe_choice" =~ ^[Yy]$ ]]; then
    echo -e "Wiping previous build artifacts...\n"
    wipe_build
else
    echo -e "Skipping wipe. Hot reloading the existing build.\n"
fi

if [ $choice -eq 1 ]; then
    check_msvc_target
    echo -e "Building for MSVC...\n"
    cargo build --release --target=x86_64-pc-windows-msvc
    cargo run
elif [ $choice -eq 2 ]; then
    check_wasm_target
    echo -e "Building for WebAssembly...\n"
    cargo build --release --target=wasm32-unknown-unknown
    wasm-pack build --target web
    # wasm-bindgen target/wasm32-unknown-unknown/release/wasm_wgpu_w.wasm --out-dir wasm --target web
else
    echo -e "Invalid choice. Exiting.\n"
    exit 1
fi
