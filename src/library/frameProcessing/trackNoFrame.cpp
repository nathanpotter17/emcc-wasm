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

// Load Dlib's face detector and shape predictor
dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
dlib::shape_predictor sp;

// Function to process frame data
EXTERN EMSCRIPTEN_KEEPALIVE void process_frame(unsigned char* data, int width, int height) {
    cv::Mat frame(height, width, CV_8UC4, data);
    cv::Mat frameBGR;
    cv::cvtColor(frame, frameBGR, cv::COLOR_RGBA2BGR);

    dlib::cv_image<dlib::bgr_pixel> dlibFrame(frameBGR);

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

        // Log limited eye region information
        EM_ASM({
            console.log('Left Eye Center:', $0, $1);
            console.log('Right Eye Center:', $2, $3);
        }, leftEye[0].x, leftEye[0].y, rightEye[0].x, rightEye[0].y);
    }
}

int main() {
    // Load shape predictor
    try {
        dlib::deserialize("/shape_predictor_68_face_landmarks.dat") >> sp;
    } catch (dlib::serialization_error& e) {
        EM_ASM({ console.error("Error loading shape predictor:", UTF8ToString($0)); }, e.what());
        return 1;
    }

    EM_ASM({ console.log("Dlib face detector and shape predictor loaded successfully"); });
    return 0;
}
