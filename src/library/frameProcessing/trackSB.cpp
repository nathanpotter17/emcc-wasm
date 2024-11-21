#include <opencv2/opencv.hpp>
#include <dlib/opencv.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <iostream>

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

// Global variables
cv::Mat frame; // Frame for processing
dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
bool frameReady = false; // Flag to signal when a new frame is ready

// Initialize the canvas and webcam stream
EM_JS(void, initCanvasAndWebcam, (), {
    const canvas = document.createElement('canvas');
    canvas.width = 640; // Default width
    canvas.height = 480; // Default height
    document.body.appendChild(canvas);
    Module.canvas = canvas;

    const video = document.createElement('video');
    video.setAttribute('autoplay', true);
    video.setAttribute('playsinline', true);
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;

            video.onloadedmetadata = () => {
                //canvas.width = video.videoWidth;
                //canvas.height = video.videoHeight;
                console.log("Webcam stream initialized");
            };

            const ctx = canvas.getContext('2d', { willReadFrequently: true });
            const drawToCanvas = () => {
                
                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

                // Copy frame data to WASM
                const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
                const buffer = Module._malloc(imageData.data.length);
                Module.HEAPU8.set(imageData.data, buffer);

                Module._onWebcamFrame(buffer, canvas.width, canvas.height, imageData.data.length);

                // process the frame
                Module._solveFrame();

                Module._free(buffer);

                requestAnimationFrame(drawToCanvas);
            };
            drawToCanvas();
        })
        .catch(err => {
            console.error("Webcam access denied:", err);
        });
});

// Callback to handle webcam frames
EXTERN EMSCRIPTEN_KEEPALIVE void onWebcamFrame(unsigned char *data, int width, int height, int dataSize) {
    cv::Mat temp(height, width, CV_8UC4, data); // RGBA data
    cv::cvtColor(temp, frame, cv::COLOR_RGBA2BGR); // Convert to BGR
    frameReady = true; // Signal that a new frame is ready for processing
}

// Process the frame for face detection and render results
EXTERN EMSCRIPTEN_KEEPALIVE void solveFrame() {
    if (!frameReady || frame.empty()) {
        EM_ASM({console.log("No new frame available");});
        return; // Skip if no new frame is available
    }

    frameReady = false; // Reset the flag
    dlib::cv_image<dlib::bgr_pixel> cimg(frame);
    std::vector<dlib::rectangle> faces = detector(cimg);

    for (const auto& face : faces) {
        cv::rectangle(frame,
                      cv::Point(face.left(), face.top()),
                      cv::Point(face.right(), face.bottom()),
                      cv::Scalar(255, 0, 0), 2); // Blue rectangle
    }

    // Convert to RGBA for rendering
    cv::Mat rgbaFrame;
    cv::cvtColor(frame, rgbaFrame, cv::COLOR_BGR2RGBA);

    // Render to canvas
    EM_ASM({
        const canvas = Module.canvas;
        const ctx = canvas.getContext('2d', { willReadFrequently: true });
        const imgData = new ImageData(new Uint8ClampedArray(HEAPU8.subarray($0, $0 + $1)), $2, $3);
        ctx.putImageData(imgData, 0, 0);
        console.log("Frame rendered");
    }, rgbaFrame.data, rgbaFrame.total() * rgbaFrame.elemSize(), rgbaFrame.cols, rgbaFrame.rows);
}

int main() {
    initCanvasAndWebcam();
    // cancel the current main loop
    // emscripten_cancel_main_loop();
    // Replace with custom capture mechanism if needed for frames
    // emscripten_set_main_loop(mainLoop, 0, 0);
    return 0;
}