function callJSFunc(iterations) {
  let totalOperationTime = 0;

  for (let i = 0; i < iterations; i++) {
    const start = performance.now();

    // create vectors
    const vec1 = [0.00001, 0.00001, 0.00001]; // imitate the C code for float allocation

    const vec2 = [0.00001, 0.00001, 0.00001];

    // emulate exactly what happens in C;
    vec1[0] = Math.random();
    vec1[1] = Math.random();
    vec1[2] = Math.random();

    vec2[0] = Math.random();
    vec2[1] = Math.random();
    vec2[2] = Math.random();

    // add
    const sum = [0, 0, 0];
    sum[0] = vec1[0] + vec2[0];
    sum[1] = vec1[1] + vec2[1];
    sum[2] = vec1[2] + vec2[2];

    // subtract
    const diff = [0, 0, 0];
    diff[0] = vec1[0] - vec2[0];
    diff[1] = vec1[1] - vec2[1];
    diff[2] = vec1[2] - vec2[2];

    // scale
    const scaled1 = [0, 0, 0];
    scaled1[0] = vec1[0] * 2;
    scaled1[1] = vec1[1] * 2;
    scaled1[2] = vec1[2] * 2;

    const scaled2 = [0, 0, 0];
    scaled2[0] = vec2[0] * 2;
    scaled2[1] = vec2[1] * 2;
    scaled2[2] = vec2[2] * 2;

    const end = performance.now();
    totalOperationTime += end - start;
  }

  console.log("Test Results:", {
    Iterations: iterations,
    TotalTime: `${totalOperationTime.toFixed(2)} ms`,
    TimePerIteration: `${totalOperationTime / iterations} ms`,
  });
}

setTimeout(() => {
  callJSFunc(10000);

  callJSFunc(50000);

  callJSFunc(100000);
}, 3000);
