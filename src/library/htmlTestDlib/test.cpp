// TUTORIAL - BUILD COMMAND

// INCLUDES
// -I"C:/Users/natha/emsdk/upstream/emscripten/cache/sysroot/include"
// C:/Users/natha/Desktop/DLIBEMC/install/include

// Ensure we preload files. emscripten will generate a .data file that it will then look for. pay
// attention to the browser console for which path it expects the file to be at. move the .data file.
// in order to use ccall effectively, we need to export the function. we can do this by using the extern "C"
// keyword in C++ or by using the EMSCRIPTEN_KEEPALIVE macro.

// CCALL Build command
// emcc test.cpp -o build/ccall/face.js -I"../cmake/DLIBEMC/install/include" -I"C:/emsdk/upstream/emscripten/cache/sysroot/include" -L"../cmake/DLIBEMC/static_build/dlib" -ldlib -s EXPORT_ALL=1 -s EXPORTED_RUNTIME_METHODS=["ccall"] -s WASM=1 -s STACK_OVERFLOW_CHECK=2 -s ENVIRONMENT=web -s DISABLE_EXCEPTION_CATCHING=0 -s ASSERTIONS=1 --preload-file "C:/Users/natha/Documents/Work/Refactor Games/Eye Tracking/pyTrack/webapp/cpp/build/htmlTestDlib/build/monalisa.jpg@/monalisa.jpg"

#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_io.h>
#include <iostream>
#include <emscripten/emscripten.h>

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

EXTERN EMSCRIPTEN_KEEPALIVE int detect_faces() {
    EM_ASM({
        console.log("Starting Detect function!");
    });
    // Initialize the face detector
    dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();

    // Load the image from the provided path
    dlib::array2d<dlib::rgb_pixel> img;
    dlib::load_image(img, "/monalisa.jpg"); // emcc virtual file system path

    EM_ASM({
        console.log("Image Loaded!");
    });

    // Detect faces in the image
    std::vector<dlib::rectangle> faces = detector(img);

    EM_ASM_({
        console.log("Detected Faces: " + $0);
    }, faces.size());

    // std::cout << "Faces detected: " << faces.size() << std::endl;

    // Return the number of faces detected
    return faces.size();
}

int main() {
    EM_ASM({
        console.log("Starting main function!");
    });

    return 0;
}