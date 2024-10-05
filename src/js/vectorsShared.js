// use shared memory for the vectors. this is a bit faster than allocating each and every time
async function init() {
  const wasmModule = await WebAssembly.instantiateStreaming(
    fetch("build/vectorsShared.wasm"),
    {
      wasi_snapshot_preview1: {
        environ_sizes_get: () => 0,
        environ_get: () => 0,
        proc_exit: (exitCode) => {
          console.log(`Process exited with code ${exitCode}`);
        },
        fd_write: () => 0,
        fd_seek: () => 0,
        fd_close: () => 0,
      },
      env: {},
    }
  );
  console.log("WASM Module:", wasmModule);
  const vectorMath = wasmModule.instance.exports;

  // Get access to shared memory
  const memoryBuffer = new Float32Array(vectorMath.memory.buffer);

  window.vectorMath = vectorMath;
  window.memoryBuffer = memoryBuffer;
}

function callFunctions(numIterations = 10000) {
  const vectorMath = window.vectorMath;
  const memoryBuffer = window.memoryBuffer;

  let totalOperationTime = 0;

  for (let i = 0; i < numIterations; i++) {
    const start = performance.now();

    // Set vector components in shared memory
    const vec1Index = i % 10000; // Rotate through indices
    const vec2Index = (i + 1) % 10000;
    const resultIndex = (i + 2) % 10000;

    vectorMath.set_vector(
      vec1Index,
      Math.random(),
      Math.random(),
      Math.random()
    );
    vectorMath.set_vector(
      vec2Index,
      Math.random(),
      Math.random(),
      Math.random()
    );

    // Perform operations in WASM
    vectorMath.add_vectors(vec1Index, vec2Index, resultIndex);

    // Optional: Read result from shared memory
    const x = memoryBuffer[resultIndex * 3];
    const y = memoryBuffer[resultIndex * 3 + 1];
    const z = memoryBuffer[resultIndex * 3 + 2];

    const end = performance.now();
    totalOperationTime += end - start;
  }

  console.log("Test Results:", {
    Iterations: numIterations,
    TotalTime: `${totalOperationTime.toFixed(2)} ms`,
    AverageTimePerIteration: `${totalOperationTime / numIterations} ms`,
  });
}

init();

setTimeout(() => {
  callFunctions(10000);
  callFunctions(50000);
  callFunctions(100000);
}, 3000);
