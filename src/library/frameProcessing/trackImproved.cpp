#include <opencv2/opencv.hpp>
#include <dlib/opencv.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <iostream>
#include <cstring>

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

// Global constants and variables
constexpr int FRAME_WIDTH = 320;
constexpr int FRAME_HEIGHT = 240;
constexpr int FRAME_CHANNELS = 4; // RGBA
constexpr int FRAME_SIZE = FRAME_WIDTH * FRAME_HEIGHT * FRAME_CHANNELS;
unsigned char* imageData = (unsigned char*)malloc(FRAME_SIZE * sizeof(unsigned char)); // Global buffer for image data
cv::Mat frame(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC3); // BGR frame for processing
cv::Mat rgbaFrame(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC4); // RGBA for rendering
dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
bool frameReady = false;

// Getter to retrieve the buffer address in JavaScript, thus not exposing malloc or free to JavaScript.
EXTERN EMSCRIPTEN_KEEPALIVE unsigned char* getSharedBuffer() {
    return imageData;
}

// JavaScript integration to initialize canvas and webcam - Main loop is contained here in C++ Land to ensure we're in control
// of the browser's update loop. This is a more efficient way to handle the webcam feed and rendering, as opposed to calling things from JavaScript.
EM_JS(void, initCanvasAndWebcam, (), {
    const canvas = document.createElement('canvas');
    canvas.width = 320; // Lower resolution for performance
    canvas.height = 240; // Lower resolution for performance
    document.body.appendChild(canvas);
    Module.canvas = canvas;

    const video = document.createElement('video');
    video.setAttribute('autoplay', true);
    video.setAttribute('playsinline', true);
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
            const ctx = canvas.getContext('2d', { willReadFrequently: true });

            // Retrieve the shared buffer pointer from C++
            const sharedBuffer = Module._getSharedBuffer();

            function process() {
                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
                const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

                Module.HEAPU8.set(imageData.data, sharedBuffer); // Copy the image data to the shared buffer
                // Pass the shared buffer to the C++ function
                Module._onWebcamFrame(sharedBuffer, canvas.width, canvas.height, imageData.data.length);

                Module._solveFrame(); // Call rendering logic
            }

            setInterval(process, 1000 / 60); // Call process() at 60 FPS
        })
        .catch(err => {
            console.error("Webcam access denied:", err);
        });
});

// Process incoming webcam frame
EXTERN EMSCRIPTEN_KEEPALIVE void onWebcamFrame(unsigned char* data, int width, int height, int dataSize) {
    cv::Mat temp(height, width, CV_8UC4, data); // Create a temporary RGBA Mat using incoming
    std::memcpy(imageData, data, dataSize); // Copy data to global buffer
    cv::cvtColor(temp, frame, cv::COLOR_RGBA2BGR); // Convert to BGR
    frameReady = true; // Mark frame as ready
}

// Process the frame for face detection and render
EXTERN EMSCRIPTEN_KEEPALIVE void solveFrame() {
    if (!frameReady || frame.empty()) {
        EM_ASM({ console.log("No new frame available"); });
        return;
    }

    frameReady = false; // Reset the flag

    // One liner to interpret the OpenCV Mat as a Dlib image
    dlib::cv_image<dlib::bgr_pixel> cimg(frame);
    // process the frame using the detector and cimg as input
    std::vector<dlib::rectangle> faces = detector(cimg);

    for (const auto& face : faces) {
        cv::rectangle(frame,
                      cv::Point(face.left(), face.top()),
                      cv::Point(face.right(), face.bottom()),
                      cv::Scalar(255, 0, 0), 2); // Draw a blue rectangle on the frame once face(s) are detected
    }

    // Convert BGR frame back to RGBA for rendering
    cv::cvtColor(frame, rgbaFrame, cv::COLOR_BGR2RGBA);

    // Render frame on canvas. Start address of the RGBA Frame. Second arg: Size in bytes of the image. Convert bytes to UINT8 for rendering.
    // Image Data: new ImageData(dataArray, width, height, settings(optional))

    // See https://emscripten.org/docs/api_reference/module.html#creating-the-module-object for interacting with the Module object, however exporting
    // this function adds overhead instead of just calling the function directly here using the EM_ASM macro. Also could lead to race conditions.
    EM_ASM({
        const canvas = Module.canvas;
        const ctx = canvas.getContext('2d', { willReadFrequently: true });

        // Directly access the memory buffer from JavaScript
        // https://emscripten.org/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html#access-memory-from-javascript
        
        const imgData = new ImageData(new Uint8ClampedArray(HEAPU8.subarray($0, $0 + $1)), $2, $3);
        ctx.putImageData(imgData, 0, 0);
        console.log("Frame rendered");
    }, rgbaFrame.data, FRAME_SIZE, FRAME_WIDTH, FRAME_HEIGHT);
}

int main() {
    // Check if memory allocation was successful
    if (!imageData) {
        EM_ASM({ console.error("Memory allocation failed"); });
        return 1;
    }
    // Start processing
    initCanvasAndWebcam();

    return 0;
}