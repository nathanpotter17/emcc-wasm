#!/bin/bash

# Function to build HTML
build_html() {
    emcc src/cpp/gol.cpp -o build/gol.html
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
    wasm)
        build_wasm
        ;;
    simple)
        build_simple
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
    *)  
        echo
        echo "Usage: $0 [command]"
        echo 
        echo "Available commands:"
        echo "  html         Build HTML"
        echo "  c-libs       Build C with libraries"
        echo "  accessor     Build accessor (see index.html)"
        echo "  wasm         Build WASM"
        echo "  simple       Build simple WASM (see index.html)"
        echo "  wat          Build WAT"
        echo "  watshared    Build shared memory example - supports multiple threads"
        echo "  asc          Build ASC (AssemblyScript)"
        echo "  vec          Build VEC (see vectors.js)"
        exit 1
        ;;
esac
