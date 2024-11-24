# Building the finalTrackWASM project

## General

`11/20/24` - trackSB.cpp is the latest version of the tracker. It is a simplified version of the tracker that uses the dlib library for face detection and tracking. The tracker is able to track the face at about 1 fps at the right resolution. Memory usage is a 1.2MB per frame,
which is when at the default canvas size of 640x480 resolution.

`11/22/24` - trackIMP.cpp is the latest version of the tracker. It is a copy of trackSB, just with memory optimizations.

## Notes

Note Memory Requirements for EMCC Settings:

### INITIAL_HEAP

The initial amount of heap memory available to the program. This is the memory region available for dynamic allocations via sbrk, malloc and new.

Unlike INITIAL_MEMORY, this setting allows the static and dynamic regions of your programs memory to independently grow. In most cases we recommend using this setting rather than INITIAL_MEMORY. However, this setting does not work for imported memories (e.g. when dynamic linking is used).

Default value: 16777216

### INITIAL_MEMORY

The initial amount of memory to use. Using more memory than this will cause us to expand the heap, which can be costly with typed arrays: we need to copy the old heap into a new one in that case. If ALLOW_MEMORY_GROWTH is set, this initial amount of memory can increase later; if not, then it is the final and total amount of memory.

By default, this value is calculated based on INITIAL_HEAP, STACK_SIZE, as well the size of static data in input modules.

(This option was formerly called TOTAL_MEMORY.)

Default value: -1

### MAXIMUM_MEMORY

Set the maximum size of memory in the wasm module (in bytes). This is only relevant when ALLOW_MEMORY_GROWTH is set, as without growth, the size of INITIAL_MEMORY is the final size of memory anyhow.

Note that the default value here is 2GB, which means that by default if you enable memory growth then we can grow up to 2GB but no higher. 2GB is a natural limit for several reasons:

- If the maximum heap size is over 2GB, then pointers must be unsigned in JavaScript, which increases code size. We don’t want memory growth builds to be larger unless someone explicitly opts in to >2GB+ heaps.

- Historically no VM has supported more >2GB+, and only recently (Mar 2020) has support started to appear. As support is limited, it’s safer for people to opt into >2GB+ heaps rather than get a build that may not work on all VMs.

To use more than 2GB, set this to something higher, like 4GB.

(This option was formerly called WASM_MEM_MAX and BINARYEN_MEM_MAX.)

Default value: 2147483648

### ALLOW_MEMORY_GROWTH

If false, we abort with an error if we try to allocate more memory than we can (INITIAL_MEMORY). If true, we will grow the memory arrays at runtime, seamlessly and dynamically. See https://code.google.com/p/v8/issues/detail?id=3907 regarding memory growth performance in chrome. Note that growing memory means we replace the JS typed array views, as once created they cannot be resized. (In wasm we can grow the Memory, but still need to create new views for JS.) Setting this option on will disable ABORTING_MALLOC, in other words, ALLOW_MEMORY_GROWTH enables fully standard behavior, of both malloc returning 0 when it fails, and also of being able to allocate more memory from the system as necessary.

Default value: false

### SHARED_MEMORY

If 1, target compiling a shared Wasm Memory. [compile+link] - affects user code at compile and system libraries at link.

Default value: false

### Large Memory Requirements

See EMCC Setting -s USE_CLOSURE_COMPILER=1 for optimizing the JS output.

Also, EMCC Setting -s INITIAL_MEMORY=16777216 for setting the initial memory size in bytes.

See this article for using WASM where there are large memory requirements:

https://users.rust-lang.org/t/wasm32-stack-size-u32-64-64/72671/5

## Commands

emcc trackerRevised.cpp -o build/ccall/tracking.js -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/install/include/opencv4" -I"C:/Users/natha/emsdk/upstream/emscripten/cache/sysroot/include" -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/dlib/DLIBEMC/install/include" -L"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/library" -lopencv_core -lopencv_imgproc -ldlib -s ALLOW_MEMORY_GROWTH=1 -s EXPORT_ALL=1 -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]' --preload-file "C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/shape_predictor_68_face_landmarks.dat@/shape_predictor_68_face_landmarks.dat"

emcc trackerRevised.cpp -o build/html/tracking.html -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/install/include/opencv4" -I"C:/Users/natha/emsdk/upstream/emscripten/cache/sysroot/include" -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/dlib/DLIBEMC/install/include" -L"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/library" -lopencv_core -lopencv_imgproc -ldlib -s ALLOW_MEMORY_GROWTH=1 -s NO_EXIT_RUNTIME=1 --preload-file "C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/shape_predictor_68_face_landmarks.dat@/shape_predictor_68_face_landmarks.dat"

prelim - -s STACK_SIZE=268435456 - stack overflow and out of memory access

emcc trackers/facedetection/trackNF.cpp -o build/ccall/tracking.js -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/install/include/opencv4" -I"C:/Users/natha/emsdk/upstream/emscripten/cache/sysroot/include" -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/dlib/DLIBEMC/install/include" -L"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/library" -lopencv_core -lopencv_imgproc -ldlib -s ALLOW_MEMORY_GROWTH=1 -s STACK_OVERFLOW_CHECK=1 -s EXPORTED_FUNCTIONS=["_main","_malloc","_free","_process_frame"] -s EXPORTED_RUNTIME_METHODS='["ccall"]' -s DISABLE_EXCEPTION_CATCHING=0 --preload-file "C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/shape_predictor_68_face_landmarks.dat@/shape_predictor_68_face_landmarks.dat"

sandbox -

emcc trackers/facedetection/trackIMP.cpp -o build/ccall/tracking.js -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/install/include/opencv4" -I"C:/Users/natha/emsdk/upstream/emscripten/cache/sysroot/include" -I"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/cmake/dlib/DLIBEMC/install/include" -L"C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/wasm-cpp/build/finalTrackWASM/library" -lopencv_core -lopencv_imgproc -ldlib -s OFFSCREENCANVAS_SUPPORT=1 -s EXPORTED_FUNCTIONS="['_main', '_onWebcamFrame','_solveFrame','_malloc']" -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap"]'
