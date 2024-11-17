#include <opencv2/opencv.hpp>
#include <dlib/opencv.h>
#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing.h>
#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <iostream>

// Global Variables for webcam stream and eye tracking
cv::Mat frame;
dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
dlib::shape_predictor predictor;

const int LEFT_EYE_POINTS[] = {36, 37, 38, 39, 40, 41};
const int RIGHT_EYE_POINTS[] = {42, 43, 44, 45, 46, 47};
const cv::Scalar CIRCLE_COLOR(0, 0, 255); // Red color for pupils

// Get eye region from frame via Dlib's landmark detections
std::pair<cv::Mat, cv::Point> get_eye_image(const cv::Mat &frame, const dlib::full_object_detection &landmarks, const int *eye_points, int size) {
    std::vector<cv::Point> eye;
    for (int i = 0; i < size; ++i) {
        eye.emplace_back(landmarks.part(eye_points[i]).x(), landmarks.part(eye_points[i]).y());
    }
    cv::Rect eye_rect = cv::boundingRect(eye);
    cv::Mat eye_image = frame(eye_rect);
    return {eye_image, eye_rect.tl()};
}

// Detect the pupil in the eye image
std::optional<cv::Point> detect_pupil(const cv::Mat &eye_image) {
    cv::Mat gray_eye, threshold;
    cv::cvtColor(eye_image, gray_eye, cv::COLOR_BGR2GRAY);
    cv::adaptiveThreshold(gray_eye, threshold, 255, cv::ADAPTIVE_THRESH_GAUSSIAN_C,
                          cv::THRESH_BINARY_INV, 11, 2);

    std::vector<std::vector<cv::Point>> contours;
    cv::findContours(threshold, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    if (!contours.empty()) {
        auto largest_contour = *std::max_element(contours.begin(), contours.end(),
            [](const std::vector<cv::Point> &a, const std::vector<cv::Point> &b) {
                return cv::contourArea(a) < cv::contourArea(b);
            });

        cv::Point2f center;
        float radius;
        cv::minEnclosingCircle(largest_contour, center, radius);

        if (radius > 3 && radius < 15) {
            return cv::Point(center);
        }
    }
    return std::nullopt;
}

EM_JS(void, render_frame, (const unsigned char *data, int dataSize, int width, int height), {
    const canvas = Module.canvas;
    const ctx = canvas.getContext('2d');
    // encode the frames into raw data that WASM understands.
    const frameData = new Uint8Array(HEAPU8.buffer, data, dataSize);
    const imgData = ctx.createImageData(width, height);
    imgData.data.set(frameData);
    ctx.putImageData(imgData, 0, 0);
});

// Render the webcam frame with tracked pupils
void render() {
    if (frame.empty()) return;

    dlib::cv_image<dlib::bgr_pixel> cimg(frame);
    std::vector<dlib::rectangle> faces = detector(cimg);

    for (const auto &face : faces) {
        dlib::full_object_detection landmarks = predictor(cimg, face);

        // Process the left eye
        auto [left_eye_image, left_eye_pos] = get_eye_image(frame, landmarks, LEFT_EYE_POINTS, 6);
        auto left_pupil = detect_pupil(left_eye_image);

        // Process the right eye
        auto [right_eye_image, right_eye_pos] = get_eye_image(frame, landmarks, RIGHT_EYE_POINTS, 6);
        auto right_pupil = detect_pupil(right_eye_image);

        if (left_pupil) {
            cv::circle(frame, *left_pupil + left_eye_pos, 3, CIRCLE_COLOR, -1);
        }

        if (right_pupil) {
            cv::circle(frame, *right_pupil + right_eye_pos, 3, CIRCLE_COLOR, -1);
        }
    }

    render_frame((unsigned char*)frame.data, frame.total() * frame.elemSize(), frame.cols, frame.rows);
}

// Initialize the webcam stream and canvas
EM_JS(void, initWebcamStream, (), {
    const canvas = Module.canvas;
    const ctx = canvas.getContext('2d');

    // Access the user's webcam
    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            const video = document.createElement('video');
            video.srcObject = stream;
            video.play();  // Start playing the video stream

            // Set the canvas size to match the video
            video.onloadedmetadata = function() {
                canvas.width = video.videoWidth;
                canvas.height = video.videoHeight;

                // Start the frame drawing loop
                const drawFrame = function() {
                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);
                    requestAnimationFrame(drawFrame);
                };
                drawFrame();  // Start drawing
            };
        })
        .catch(err => {
            console.error('Webcam access denied:', err);
        });
});

int main() {
    try {
        // Load the facial landmark predictor
        dlib::deserialize("shape_predictor_68_face_landmarks.dat") >> predictor;
    } catch (const std::exception &e) {
        std::cerr << "Error loading shape predictor: " << e.what() << std::endl;
        return 1;
    }

    // Initialize the webcam stream (already handles canvas initialization)
    initWebcamStream();
    std::cout << "Webcam stream initialized!" << std::endl;

    // Set up the main loop for rendering the eye tracking
    emscripten_set_main_loop(render, 0, 1);

    return 0;
}
