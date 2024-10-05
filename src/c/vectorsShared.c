#include <stdint.h>
#include <stdlib.h>
#include <emscripten/emscripten.h>

#define MAX_VECTORS 10000

// Pre-allocated memory for vectors
static float shared_memory[MAX_VECTORS * 3];  // 3 components (x, y, z) per vector

// Function to access the shared memory
EMSCRIPTEN_KEEPALIVE float* get_shared_memory() {
    return shared_memory;
}

EMSCRIPTEN_KEEPALIVE void add_vectors(int a_index, int b_index, int result_index) {
    int base_a = a_index * 3;
    int base_b = b_index * 3;
    int base_result = result_index * 3;

    shared_memory[base_result]     = shared_memory[base_a]     + shared_memory[base_b];
    shared_memory[base_result + 1] = shared_memory[base_a + 1] + shared_memory[base_b + 1];
    shared_memory[base_result + 2] = shared_memory[base_a + 2] + shared_memory[base_b + 2];
}

EMSCRIPTEN_KEEPALIVE void sub_vectors(int a_index, int b_index, int result_index) {
    int base_a = a_index * 3;
    int base_b = b_index * 3;
    int base_result = result_index * 3;

    shared_memory[base_result]     = shared_memory[base_a]     - shared_memory[base_b];
    shared_memory[base_result + 1] = shared_memory[base_a + 1] - shared_memory[base_b + 1];
    shared_memory[base_result + 2] = shared_memory[base_a + 2] - shared_memory[base_b + 2];
}

EMSCRIPTEN_KEEPALIVE void mul_scalar(int v_index, float scalar, int result_index) {
    int base_v = v_index * 3;
    int base_result = result_index * 3;

    shared_memory[base_result]     = shared_memory[base_v]     * scalar;
    shared_memory[base_result + 1] = shared_memory[base_v + 1] * scalar;
    shared_memory[base_result + 2] = shared_memory[base_v + 2] * scalar;
}

EMSCRIPTEN_KEEPALIVE void set_vector(int index, float x, float y, float z) {
    int base = index * 3;
    shared_memory[base]     = x;
    shared_memory[base + 1] = y;
    shared_memory[base + 2] = z;
}

EMSCRIPTEN_KEEPALIVE void get_vector(int index, float* x, float* y, float* z) {
    int base = index * 3;
    *x = shared_memory[base];
    *y = shared_memory[base + 1];
    *z = shared_memory[base + 2];
}

int main () {
    return 0;
}
