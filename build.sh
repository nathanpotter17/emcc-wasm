#!/bin/bash

# Function to build HTML
build_html() {
    emcc src/cpp/gol.cpp -o build/gol.html
}

build_wat2wasi() {
    wat2wasm src/wasi/sysclock.wat -o build/wasiClock.wasm
}

build_wasi() {
    emcc src/wasi/hello.c -o build/wasiExample.wasm -s STANDALONE_WASM=1
}

build_wasiPure() {
    emcc src/wasi/hello.c -o build/wasiPure.wasm -s PURE_WASI=1
}

run_wasmtime() {
    wasmtime build/clock.wasm
}

# Function to build the shared mem example
build_sm() {
    wat2wasm src/wasm/shared_memory.wat -o build/shared_memory.wasm --enable-threads
}

# Function to build C with libraries
build_c_with_libs() {
    emcc example.c -s LDFLAGS=['-lSDL2'] -o output.html
}

# Function to build accessor
build_accessor() {
    emcc -o build/gol.js src/js/gol.cpp -s EXPORTED_RUNTIME_METHODS=['ccall'] -s EXPORTED_FUNCTIONS=_main,_myFunction
}

# Function to build WASM
build_wasm() {
    emcc src/cpp/gol.cpp -o build/gol.wasm -s STANDALONE_WASM=1 -s EXPORTED_FUNCTIONS=[_main,_myFunction]
}

# Function to build simple WASM
build_simple() {
    emcc src/c/simple.c -o build/simple.wasm -s STANDALONE_WASM=1 -s EXPORT_ALL=1
}

# Function to build WAT
build_wat() {
    wat2wasm src/wasm/memory.wat -o build/memory.wasm
}

# Function to build ASC
build_asc() {
    asc src/ts-asc/fib.ts --outFile build/assembly.wasm --optimize
}

# Function to build VEC
build_vec() {
    emcc src/c/vectors.c -o build/vectors.wasm -s STANDALONE_WASM=1 -s EXPORTED_FUNCTIONS=_alloc_vector,_dealloc_vector,_add_vectors,_sub_vectors,_mul_scalar
}

build_vecs() {
    emcc src/c/vectorsShared.c -o build/vectorsShared.wasm -s STANDALONE_WASM=1 -s EXPORT_ALL=1
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
    c-libs)
        build_c_with_libs
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
    wasmtime)
        run_wasmtime
        ;;
    wasi)
        build_wasi
        ;;
    wasiPure)
        build_wasiPure
        ;;
    wasiClock)
        build_wat2wasi
        ;;
    wat)
        build_wat
        ;;
    watshared)
        build_sm
        ;;
    asc)
        build_asc
        ;;
    vec)
        build_vec
        ;;
    vecs)
        build_vecs
        ;;
    *)  
        echo
        echo "Usage: $0 [command]"
        echo 
        echo "Available commands:"
        echo "  html         Build HTML"
        echo "  c-libs       Build C with libraries"
        echo "  accessor     Build accessor (see index.html)"
        echo "  simple       Build simple WASM (see index.html)"
        echo "  wasm         Build WASM"
        echo "  wasmtime     Run WASM with Wasmtime, via EMCC emitted standalone WASM (C based)"
        echo "  wasi         Build WASI example (C based)"
        echo "  wasiPure     Build WASI example with emcc's experimental pure WASI (C based)"
        echo "  wasiClock    Build WASI clock example using wat2wasm - run anywhere WASI bindings are available"
        echo "  wat          Build WAT"
        echo "  watshared    Build shared memory example - supports multiple threads"
        echo "  asc          Build ASC (AssemblyScript)"
        echo "  vec          Build VEC (see vectors.js)"
        echo "  vecs         Build VEC Shared (see vectorsShared.js)"
        exit 1
        ;;
esac
