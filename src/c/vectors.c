#include <stdint.h>
#include <stdlib.h>
#include <emscripten/emscripten.h>

// Define vector structure
typedef struct {
    float x;
    float y;
    float z;
} Vector;

// Function to allocate memory for vectors
EMSCRIPTEN_KEEPALIVE Vector* alloc_vector() {
    return (Vector*)malloc(sizeof(Vector));
}

// Function to deallocate memory
EMSCRIPTEN_KEEPALIVE void dealloc_vector(Vector* v) {
    free(v);
}

// Vector addition
EMSCRIPTEN_KEEPALIVE Vector* add_vectors(const Vector* a, const Vector* b) {
    Vector* result = alloc_vector();
    result->x = a->x + b->x;
    result->y = a->y + b->y;
    result->z = a->z + b->z;
    return result;
}

// Vector subtraction
EMSCRIPTEN_KEEPALIVE Vector* sub_vectors(const Vector* a, const Vector* b) {
    Vector* result = alloc_vector();
    result->x = a->x - b->x;
    result->y = a->y - b->y;
    result->z = a->z - b->z;
    return result;
}

// Vector multiplication
EMSCRIPTEN_KEEPALIVE Vector* mul_scalar(const Vector* v, float scalar) {
    Vector* result = alloc_vector();
    result->x = v->x * scalar;
    result->y = v->y * scalar;
    result->z = v->z * scalar;
    return result;
}

// Helper function to get vector components
EMSCRIPTEN_KEEPALIVE float get_component(Vector* v, int index) {
    switch(index) {
        case 0:
            return v->x;
        case 1:
            return v->y;
        case 2:
            return v->z;
        default:
            return 0.0f;
    }
}

// Helper functions to set vector components
EMSCRIPTEN_KEEPALIVE void set_component(Vector* v, int index, float value) {
    switch(index) {
        case 0:
            v->x = value;
            break;
        case 1:
            v->y = value;
            break;
        case 2:
            v->z = value;
            break;
    }
}


int main () {
    return 0;
}