#include <opencv2/opencv.hpp>
#include <dlib/opencv.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <iostream>
#include <cstring> // For memcpy

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

unsigned char* imageData = (unsigned char*)malloc(FRAME_SIZE * sizeof(unsigned char));
cv::Mat frame(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC3); // BGR frame for processing
cv::Mat rgbaFrame(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC4); // RGBA for rendering
dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
bool frameReady = false;

// JavaScript integration to initialize canvas and webcam
EM_JS(void, initCanvasAndWebcam, (), {
    const canvas = document.createElement('canvas');
    canvas.width = 320; // Default width
    canvas.height = 240; // Default height
    document.body.appendChild(canvas);
    Module.canvas = canvas;

    const video = document.createElement('video');
    video.setAttribute('autoplay', true);
    video.setAttribute('playsinline', true);
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;
            const ctx = canvas.getContext('2d', { willReadFrequently: true });

            let sharedBuffer = null; // Persistent memory buffer

            function drawToCanvas() {
                const canvas = Module.canvas;
                const ctx = canvas.getContext('2d', { willReadFrequently: true });

                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
                const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

                // Allocate memory once and reuse the buffer
                if (!sharedBuffer) {
                    sharedBuffer = Module._malloc(imageData.data.length); // Allocate once
                }

                // Copy the frame data to the persistent buffer
                Module.HEAPU8.set(imageData.data, sharedBuffer);

                // Call the C++ function to process the frame
                Module._onWebcamFrame(sharedBuffer, canvas.width, canvas.height, imageData.data.length);
                Module._solveFrame(); // Process the frame

                // Optionally free the buffer if resizing occurs (not in this example)
                
            }

            setInterval(drawToCanvas, 1000 / 15); // 15 FPS
        })
        .catch(err => {
            console.error("Webcam access denied:", err);
        });
});

// Process incoming webcam frame
EXTERN EMSCRIPTEN_KEEPALIVE void onWebcamFrame(unsigned char* data, int width, int height, int dataSize) {
    cv::Mat temp(height, width, CV_8UC4, data); // Create a temporary RGBA Mat
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

    // Perform face detection
    dlib::cv_image<dlib::bgr_pixel> cimg(frame);
    std::vector<dlib::rectangle> faces = detector(cimg);

    for (const auto& face : faces) {
        cv::rectangle(frame,
                      cv::Point(face.left(), face.top()),
                      cv::Point(face.right(), face.bottom()),
                      cv::Scalar(255, 0, 0), 2); // Blue rectangle
    }

    // Convert BGR frame back to RGBA for rendering
    cv::cvtColor(frame, rgbaFrame, cv::COLOR_BGR2RGBA);

    // Render frame on canvas
    EM_ASM({
        const canvas = Module.canvas;
        const ctx = canvas.getContext('2d', { willReadFrequently: true });
        const imgData = new ImageData(new Uint8ClampedArray(HEAPU8.subarray($0, $0 + $1)), $2, $3);
        ctx.putImageData(imgData, 0, 0);
        console.log("Frame rendered");
    }, rgbaFrame.data, FRAME_SIZE, FRAME_WIDTH, FRAME_HEIGHT);
}

int main() {
    if (!imageData) {
        EM_ASM({ console.error("Memory allocation failed"); });
        return 1;
    }

    initCanvasAndWebcam();
    return 0;
}
