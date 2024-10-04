async function init() {
  const wasmModule = await WebAssembly.instantiateStreaming(
    fetch("build/vectors.wasm"),
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
  const vectorMath = wasmModule.instance.exports;

  window.vectorMath = vectorMath;
}

function callFunctions(numIterations = 10000) {
  const vectorMath = window.vectorMath;

  let totalOperationTime = 0;

  for (let i = 0; i < numIterations; i++) {
    const start = performance.now();

    // Create vectors
    const v1Index = vectorMath.alloc_vector();
    const v2Index = vectorMath.alloc_vector();

    // Initialize vectors with random values
    vectorMath.set_component(v1Index, 0, Math.random());
    vectorMath.set_component(v1Index, 1, Math.random());
    vectorMath.set_component(v1Index, 2, Math.random());

    vectorMath.set_component(v2Index, 0, Math.random());
    vectorMath.set_component(v2Index, 1, Math.random());
    vectorMath.set_component(v2Index, 2, Math.random());

    // Perform operations
    const sumIndex = vectorMath.add_vectors(v1Index, v2Index);
    const diffIndex = vectorMath.sub_vectors(v1Index, v2Index);
    const scaledIndex = vectorMath.mul_scalar(v1Index, 2.0);

    // Clean up
    vectorMath.dealloc_vector(v1Index);
    vectorMath.dealloc_vector(v2Index);
    vectorMath.dealloc_vector(sumIndex);
    vectorMath.dealloc_vector(diffIndex);
    vectorMath.dealloc_vector(scaledIndex);

    const end = performance.now();
    totalOperationTime += end - start;
  }

  console.log("Test Results:", {
    Iterations: numIterations,
    TotalTime: `${totalOperationTime.toFixed(2)} ms`,
    AverageTimePerIteration: `${totalOperationTime / numIterations} ms`,
  });
}

function programInfo() {
  const vi = window.vectorMath;

  const totalMemory = vi.memory.buffer;

  console.log(
    "Total Provided Linear Memory: ",
    totalMemory.byteLength,
    "Bytes"
  );

  async function fetchWasm(url) {
    const response = await fetch(url);
    return await response.arrayBuffer();
  }
  async function usage() {
    const buffer = await fetchWasm("build/vectors.wasm");
    console.log("Program Size", buffer.byteLength, "Bytes");
    console.log(
      "Used Memory: ",
      (totalMemory.byteLength - buffer.byteLength) / 1024,
      "KB"
    );
    console.log("Unused Memory: ", buffer.byteLength / 1024, "KB");
    console.log(
      "Utilization: ",
      ((buffer.byteLength / totalMemory.byteLength) * 100).toFixed(2),
      "%"
    );
  }
  usage();
}

init();

setTimeout(() => {
  callFunctions(10000);

  callFunctions(50000);

  callFunctions(100000);
  programInfo();
}, 3000);
