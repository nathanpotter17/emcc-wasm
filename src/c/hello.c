#include <stdio.h>
#include <stdlib.h>
#include <emscripten.h>
#include <emscripten/emscripten.h>

char *message = "Hello, WASM! This is C speaking!";

EMSCRIPTEN_KEEPALIVE char *getMessage() {
    return message;
}

int main() {
    printf("%s\n", message);
    return 0;
}
