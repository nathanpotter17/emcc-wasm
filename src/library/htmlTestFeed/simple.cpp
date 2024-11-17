// TUTORIAL - BUILD COMMAND

// emcc simple.cpp -o build/simple.html -s NO_EXIT_RUNTIME=1 -s ALLOW_MEMORY_GROWTH=1

#include <emscripten/emscripten.h>
#include <emscripten/html5.h>
#include <iostream>

// Store the video stream globally
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

                // Circle properties
                let centerX = canvas.width / 2;
                let centerY = canvas.height / 2;
                const radius = 50;
                const speed = 2; // Speed of movement

                // Start drawing the video frames to the canvas
                const drawFrame = function() {
                    // Clear the canvas before drawing
                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                    
                    // Draw the video frame
                    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

                    // Update the circle's position
                    centerX += speed;  // Move the circle to the right
                    if (centerX > canvas.width + radius) { // Reset when off-screen
                        centerX = -radius;
                    }

                    // Draw the moving circle
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2, false);  // Draw a circle
                    ctx.fillStyle = 'rgba(255, 0, 0, 0.5)';  // Semi-transparent red color
                    ctx.fill();
                    ctx.closePath();

                    requestAnimationFrame(drawFrame);  // Continue drawing the next frame
                };
                drawFrame();  // Start drawing
            };
        })
        .catch(err => {
            console.error('Webcam access denied:', err);
        });
});

int main() {
    // Create and append the canvas element
    EM_ASM({
        const canvas = document.createElement('canvas');
        document.body.appendChild(canvas); // Append the canvas to the body
    });

    // Initialize webcam stream
    initWebcamStream();
    std::cout << "Webcam stream initialized!" << std::endl;

    return 0;
}
