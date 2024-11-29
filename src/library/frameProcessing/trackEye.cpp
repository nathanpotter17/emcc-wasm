#include <dlib/image_processing.h>
#include <dlib/opencv.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>
#include <emscripten/emscripten.h>

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
bool frameReady = false;

unsigned char* imageData = (unsigned char*)malloc(FRAME_SIZE * sizeof(unsigned char));
cv::Mat frameBGR(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC3); // BGR frame for processing
cv::Mat frame(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC4); // RGBA for rendering

// Load Dlib's face detector and shape predictor
dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
dlib::shape_predictor sp;

// init webcam and canvas
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

            function process() {
                ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
                const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

                if (!sharedBuffer) {
                    sharedBuffer = Module._malloc(imageData.data.length); // Allocate memory once
                }

                Module.HEAPU8.set(imageData.data, sharedBuffer);
                Module._onWebcamFrame(sharedBuffer, canvas.width, canvas.height, imageData.data.length);

                Module._process_frame(); // Call rendering logic
            }

            setInterval(process, 1000 / 60); // Capture frame at 60 FPS
        })
        .catch(err => {
            console.error("Webcam access denied:", err);
        });
});

// Process incoming webcam frame
EXTERN EMSCRIPTEN_KEEPALIVE void onWebcamFrame(unsigned char* data, int width, int height, int dataSize) {
    std::memcpy(imageData, data, dataSize); // Copy data to global buffer
    cv::Mat tempFrame(FRAME_HEIGHT, FRAME_WIDTH, CV_8UC4, imageData);
    cv::cvtColor(tempFrame, frameBGR, cv::COLOR_RGBA2BGR); // Convert to BGR once
    frameReady = true; // Signal that frame is ready for processing
}


// Function to process frame data
EXTERN EMSCRIPTEN_KEEPALIVE void process_frame() {
    if (!frameReady) return; // No frame to process

    dlib::cv_image<dlib::bgr_pixel> dlibFrame(frameBGR);

    // Reset the frameReady flag
    frameReady = false;

    // Detect faces
    const std::vector<dlib::rectangle> faces = detector(dlibFrame);

    for (const auto& face : faces) {
        // Detect landmarks
        const dlib::full_object_detection shape = sp(dlibFrame, face);

        // Preallocate and populate eye landmarks
        std::array<cv::Point, 6> leftEye, rightEye;
        for (int i = 0; i < 6; ++i) {
            leftEye[i] = cv::Point(shape.part(36 + i).x(), shape.part(36 + i).y());
            rightEye[i] = cv::Point(shape.part(42 + i).x(), shape.part(42 + i).y());
        }

        // Compute and draw pupil positions
        cv::Point leftPupil = std::accumulate(leftEye.begin(), leftEye.end(), cv::Point(0, 0)) / (int)leftEye.size();
        cv::Point rightPupil = std::accumulate(rightEye.begin(), rightEye.end(), cv::Point(0, 0)) / (int)rightEye.size();

        cv::circle(frameBGR, leftPupil, 2, cv::Scalar(0, 255, 0), -1);
        cv::circle(frameBGR, rightPupil, 2, cv::Scalar(0, 255, 0), -1);
    }

    // Convert the modified BGR frame back to RGBA
    cv::cvtColor(frameBGR, frame, cv::COLOR_BGR2RGBA);

    // Send updated frame back to canvas
    EM_ASM({
        const canvas = Module.canvas;
        const ctx = canvas.getContext('2d', { willReadFrequently: true });
        const imgData = new ImageData(new Uint8ClampedArray(HEAPU8.subarray($0, $0 + $1)), $2, $3);
        ctx.putImageData(imgData, 0, 0);
    }, frame.data, FRAME_SIZE, FRAME_WIDTH, FRAME_HEIGHT);
}

int main() {
    // Load shape predictor
    try {
        dlib::deserialize("/shape_predictor_68_face_landmarks.dat") >> sp;
    } catch (dlib::serialization_error& e) {
        EM_ASM({ console.error("Error loading shape predictor:", UTF8ToString($0)); }, e.what());
        return 1;
    }
    EM_ASM({ console.log("Dlib face detector and shape predictor loaded successfully. Program awaiting camera access."); });
    initCanvasAndWebcam();
    return 0;
}
