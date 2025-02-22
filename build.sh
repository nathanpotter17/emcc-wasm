#!/bin/bash

help() {
    echo
    echo "Usage: $0 [command]"
    echo 
    echo "For building C/C++ libraries with emcmake, see /src/library for an example."
    echo
    echo "Read the README.md for more information, and for WASI, see src/wasi and src/wasm for examples."
    echo 
    echo "Available commands:"
    echo "  html         Build HTML (root index.html, or build/gol.html)"
    echo "  accessor     Build accessor (see index.html - line 150-164)"
    echo "  simple       Build simple WASM (see index.html - line 212-263)"
    echo "  wasm         Build WASM (index.html, line 166 - 210)"
    echo "  wasi         Build WASI example (C based, runs with wasmtime)"
    echo "  wat          Build WAT (index.html, line 116 - 133)"
    echo "  watShared    Build shared memory example - supports multiple threads (index.html, line 77 - 114)"
    echo "  vec          Build VEC (C -> vectors.js, line 134 - 148)"
    echo "  vecs         Build VEC Shared (C -> vectorsShared.js, line 134 - 148)"
    echo "  help         Show a command list"
    exit 1
}

# Function to build HTML
build_html() {
    if emcc src/cpp/gol.cpp -o build/gol.html; then
        echo
        echo "HTML built successfully."
        echo "Now, open the HTML file with Live Server or any other server."
    else
        echo
        echo "HTML build failed!" >&2
        exit 1
    fi
}

build_wasi() {
    echo
    echo "Building WASI Example..."
    if emcc src/c/hello.c -o build/wasiExample.wasm -s STANDALONE_WASM=1; then
        echo "Build successful."
    else
        echo "Build failed!" >&2
        exit 1
    fi

    echo "Checking for wasmtime..."
    if ! command -v wasmtime &>/dev/null; then
        echo "Error: wasmtime is not installed or not in PATH." >&2
        exit 1
    fi

    echo "Running WASI Example with wasmtime..."
    echo
    sleep 1
    echo "Output:"
    echo
    wasmtime build/wasiExample.wasm
}

build_sm() {
    if wat2wasm src/wasm/shared_memory.wat -o build/shared_memory.wasm --enable-threads; then
        echo
        echo "Shared memory built successfully."
        echo
        echo "Uncomment the shared memory code in index.html (line 77-114) to see the output in the browser console."
        echo "Now, open the HTML file at the root with Live Server or any other server."
        echo
    else
        echo
        echo "Shared memory build failed!" >&2
        exit 1
    fi
}

build_accessor() {
    if emcc src/cpp/gol.cpp -o build/gol.js -s EXPORTED_RUNTIME_METHODS=['ccall'] -s EXPORTED_FUNCTIONS=_main,_myFunction; then
        echo
        echo "Accessor built successfully."
        echo
        echo "Uncomment the accessor code in index.html (line 150-164) to see the output in the browser console."
        echo "Now, open the HTML file at the root with Live Server or any other server."
        echo 
    else
        echo
        echo "Accessor build failed!" >&2
        exit 1
    fi
}

build_wasm() {
    if emcc src/cpp/gol.cpp -o build/gol.wasm -s STANDALONE_WASM=1 -s EXPORTED_FUNCTIONS=[_main,_myFunction]; then
        echo
        echo "WASM built successfully."
        echo
        echo "Uncomment the WASM code in index.html (line 166-210) to see the output in the browser console."
        echo "Now, open the HTML file at the root with Live Server or any other server."
        echo
    else
        echo
        echo "WASM build failed!" >&2
        exit 1
    fi
}

build_simple() {
    emcc src/c/simple.c -o build/simple.wasm -s STANDALONE_WASM=1 -s EXPORT_ALL=1
    echo
    echo "Simple WASM built successfully."
    echo
    echo "Uncomment the simple WASM code in index.html (line 212-263) to see the output in the browser console."
    echo "Now, open the HTML file at the root with Live Server or any other server."
    echo
}

build_wat() {
    if wat2wasm src/wasm/memory.wat -o build/memory.wasm; then
        echo
        echo "WAT built successfully."
        echo
        echo "Uncomment the WAT code in index.html (line 116-133) to see the output in the browser console."
        echo "Now, open the HTML file at the root with Live Server or any other server."
        echo
    else
        echo
        echo "WAT build failed!" >&2
        exit 1
    fi
}

build_vec() {
    if emcc src/c/vectors.c -o build/vectors.wasm -s STANDALONE_WASM=1 -s EXPORTED_FUNCTIONS=_alloc_vector,_dealloc_vector,_add_vectors,_sub_vectors,_mul_scalar; then
        echo
        echo "VEC built successfully."
        echo
        echo "Uncomment a part of the VEC code in vectors.js (line 134-148) to see the output in the browser console."
        echo "Now, open the HTML file at the root with Live Server or any other server."
        echo
    else
        echo
        echo "VEC build failed!" >&2
        exit 1
    fi
}

build_vecs() {
    if emcc src/c/vectorsShared.c -o build/vectorsShared.wasm -s STANDALONE_WASM=1 -s EXPORT_ALL=1; then
        echo
        echo "VEC Shared built successfully."
        echo
        echo "Uncomment a part of the VEC Shared code in vectorsShared.js (line 134-148) to see the output in the browser console."
        echo "Now, open the HTML file at the root with Live Server or any other server."
        echo
    else
        echo
        echo "VEC Shared build failed!" >&2
        exit 1
    fi
}

print_header() {
    echo -e "\033[1m\033[94m ____ ____ ____ ____ _________ ____ ____ ____ ____ \033[0m"
    echo -e "\033[1m\033[94m||E |||M |||C |||C |||       |||W |||A |||S |||M ||\033[0m"
    echo -e "\033[1m\033[94m||__|||__|||__|||__|||_______|||__|||__|||__|||__||\033[0m"
    echo -e "\033[1m\033[94m|/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|\033[0m"
    echo
    echo -e "\033[1m\033[92mEMCC WASM\033[0m"
}

print_header
# Main execution block
case "$1" in
    html)
        build_html
        ;;
    accessor)
        build_accessor
        ;;
    simple)
        build_simple
        ;;
    wasm)
        build_wasm
        ;;
    wasi)
        build_wasi
        ;;
    wat)
        build_wat
        ;;
    watShared)
        build_sm
        ;;
    vec)
        build_vec
        ;;
    vecs)
        build_vecs
        ;;
    help)
        help
        ;;
    *)  
        echo
        echo "Usage: $0 [command]"
        echo 
        echo "For building libraries with emcmake, see /src/library for an example."
        echo 
        echo "Available commands:"
        echo "  html         Build HTML"
        echo "  accessor     Build accessor"
        echo "  simple       Build simple WASM"
        echo "  wasm         Build WASM"
        echo "  wasi         Build WASI example"
        echo "  wat          Build WAT"
        echo "  watShared    Build shared memory example - supports multiple threads"
        echo "  vec          Build VEC"
        echo "  vecs         Build VEC Shared"
        echo "  help         Show a command list, show corresponding line numbers in index.html for each command."
        exit 1
        ;;
esac
