import init, { Universe } from './wasm_game_of_life.js';

async function run() {
  await init();

  const pre = document.getElementById('game-of-life-canvas');
  const universe = Universe.new();

  const renderLoop = () => {
    pre.textContent = universe.render();
    universe.tick();
    requestAnimationFrame(renderLoop);
  };

  requestAnimationFrame(renderLoop);
}

run();
