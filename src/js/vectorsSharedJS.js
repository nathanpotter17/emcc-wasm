const sharedMemory = new Float32Array(10000 * 3);

function setVector(index, x, y, z) {
  sharedMemory[index * 3] = x;
  sharedMemory[index * 3 + 1] = y;
  sharedMemory[index * 3 + 2] = z;
}

function addVectors(vec1Index, vec2Index, resultIndex) {
  const x = sharedMemory[vec1Index * 3] + sharedMemory[vec2Index * 3];
  const y = sharedMemory[vec1Index * 3 + 1] + sharedMemory[vec2Index * 3 + 1];
  const z = sharedMemory[vec1Index * 3 + 2] + sharedMemory[vec2Index * 3 + 2];

  setVector(resultIndex, x, y, z);
}

function callJSFunc(iterations) {
  let totalOperationTime = 0;

  for (let i = 0; i < iterations; i++) {
    const start = performance.now();

    // Set vector components in shared memory
    const vec1Index = i % 10000;
    const vec2Index = (i + 1) % 10000;
    const resultIndex = (i + 2) % 10000;

    setVector(vec1Index, Math.random(), Math.random(), Math.random());
    setVector(vec2Index, Math.random(), Math.random(), Math.random());

    // Perform addition in JS
    addVectors(vec1Index, vec2Index, resultIndex);

    // Optional: Read result from shared memory
    const x = sharedMemory[resultIndex * 3];
    const y = sharedMemory[resultIndex * 3 + 1];
    const z = sharedMemory[resultIndex * 3 + 2];

    const end = performance.now();
    totalOperationTime += end - start;
  }

  console.log("Test Results:", {
    Iterations: iterations,
    TotalTime: `${totalOperationTime.toFixed(2)} ms`,
    AverageTimePerIteration: `${totalOperationTime / iterations} ms`,
  });
}

setTimeout(() => {
  callJSFunc(10000);
  callJSFunc(50000);
  callJSFunc(100000);
}, 3000);
