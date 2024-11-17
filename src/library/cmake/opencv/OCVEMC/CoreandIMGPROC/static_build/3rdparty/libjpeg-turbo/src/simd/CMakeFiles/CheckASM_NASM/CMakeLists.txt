cmake_minimum_required(VERSION 3.31.0-rc1)
set(CMAKE_MODULE_PATH "C:/Users/natha/emsdk/upstream/emscripten/cmake/Modules;C:/Users/natha/emsdk/upstream/emscripten/cmake/Modules;C:/Users/natha/emsdk/upstream/emscripten/cmake/Modules;C:/Users/natha/emsdk/upstream/emscripten/cmake/Modules;C:/Users/natha/emsdk/upstream/emscripten/cmake/Modules")
project(CheckASM_NASM ASM_NASM)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/result.cmake"
  "set(CMAKE_ASM_NASM_COMPILER \"${CMAKE_ASM_NASM_COMPILER}\")\n"
  
  )