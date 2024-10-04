#include <stdio.h>
#include <emscripten.h>
#include <emscripten/emscripten.h>

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

EXTERN EMSCRIPTEN_KEEPALIVE int myFunction() {
  
  return 1;
}

// emcc will always call main, if specified in EXPORTED_FUNCTIONS as _main
int main() {
  
  return 0;
}