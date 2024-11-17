// TUTORIAL - BUILD COMMAND

// INCLUDES
// -I"./emsdk/upstream/emscripten/cache/sysroot/include"
// -I"../cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/install/include/opencv4"

// in order to use ccall effectively, we need to export the function. we can do this by using the extern "C"
// keyword in C++ or by using the EMSCRIPTEN_KEEPALIVE macro.

// may need to adjust the include command for ocv to dir 1 level up, and -lmylib will look for libmylib.a or libmylib.so., so just have a look at the lib file names.

/*
Make sure your libraries follow the standard naming convention:

Libraries must start with lib (e.g., libopencv_core.a).
Use the part after lib for the -l flag (e.g., -lopencv_core).
*/

// ccall command
// emcc ocv.cpp -o build/ccall/ocv.js -I"../cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/install/include/opencv4" -I"./emsdk/upstream/emscripten/cache/sysroot/include" -L"../cmake/opencv/OCVEMC/CoreIMGPROCandVideoIO/static_build/lib" -lopencv_core -lopencv_imgproc -s EXPORT_ALL=1 -s EXPORTED_RUNTIME_METHODS=["ccall"] -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s ENVIRONMENT=web -s ASSERTIONS=1

#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <emscripten/emscripten.h>
#include <iostream>

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

// JavaScript function to initialize the canvas
EM_JS(void, initCanvas, (), {
    if (!Module.canvas) {
        const existingCanvas = document.querySelector('canvas');
        if (existingCanvas) {
            Module.canvas = existingCanvas;
        } else {
            const canvas = document.createElement('canvas');
            canvas.width = 128;
            canvas.height = 128;
            document.body.appendChild(canvas);
            Module.canvas = canvas;
        }
    }
});

EXTERN EMSCRIPTEN_KEEPALIVE int drawGrayscale() {
    EM_ASM({ console.log("Starting OpenCV test!"); });

    // Create a blank 128x128 black image with RGBA channels
    cv::Mat image = cv::Mat::zeros(128, 128, CV_8UC4);

    // Draw a white circle in the center of the image
    cv::circle(image, cv::Point(64, 64), 30, cv::Scalar(255, 255, 255, 255), -1);

    EM_ASM({
        const imageDataLength = $0 * $1 * 4; // width * height * RGBA

        /*
            Memory alignment in JavaScript: Use Uint8ClampedArray with Module.HEAPU8.buffer for correct data interpretation.
            Explicit passing of memory address: Use reinterpret_cast<intptr_t> to ensure the correct pointer address is passed.
        */
        const rawData = new Uint8ClampedArray(Module.HEAPU8.buffer, $2, imageDataLength);

        console.log("Image data length: " + rawData.length);
        console.log("Image width (cols): " + $0);
        console.log("Image height (rows): " + $1);
        console.log("Expected length: " + imageDataLength);

        if (rawData.length !== imageDataLength) {
            console.error("Error: Image data length mismatch.");
            return;
        }

        const canvas = Module.canvas;
        const ctx = canvas.getContext('2d');

        const imageData = new ImageData(rawData, $0, $1);
        ctx.putImageData(imageData, 0, 0);
    }, image.cols, image.rows, reinterpret_cast<intptr_t>(image.data));

    EM_ASM({ console.log("Completed drawing!"); });
    return 0;
}


int main() {
    initCanvas();  // Initialize and append the canvas
    drawGrayscale(); // Call the function to draw the image
    return 0;
}