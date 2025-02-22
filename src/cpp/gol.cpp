#include <stdio.h>
#include <emscripten.h>
#include <emscripten/emscripten.h>

// A veryyy simple example of a function that will be called from JS.

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

EXTERN EMSCRIPTEN_KEEPALIVE int myFunction() {

  EM_ASM({
    console.log("Hello from C++");
  });

  return 1;
}

// emcc will always call main, if specified in EXPORTED_FUNCTIONS as _main
int main() {
  return 0;
}