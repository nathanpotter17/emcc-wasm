/* tslint:disable */
/* eslint-disable */
export class Game {
  free(): void;
  constructor();
  update(keys: string[]): void;
  draw(): void;
}
export class Obstacle {
  private constructor();
  free(): void;
}
export class SceneManager {
  private constructor();
  free(): void;
  static new(): SceneManager;
  add_obstacle(x: number, y: number, width: number, height: number): void;
  is_colliding(x: number, y: number, width: number, height: number): boolean;
  draw(context: CanvasRenderingContext2D): void;
}

export type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

export interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly __wbg_game_free: (a: number, b: number) => void;
  readonly game_new: () => number;
  readonly game_update: (a: number, b: number, c: number) => void;
  readonly game_draw: (a: number) => void;
  readonly __wbg_scenemanager_free: (a: number, b: number) => void;
  readonly scenemanager_new: () => number;
  readonly scenemanager_add_obstacle: (a: number, b: number, c: number, d: number, e: number) => void;
  readonly scenemanager_is_colliding: (a: number, b: number, c: number, d: number, e: number) => number;
  readonly scenemanager_draw: (a: number, b: any) => void;
  readonly __wbg_obstacle_free: (a: number, b: number) => void;
  readonly __wbindgen_exn_store: (a: number) => void;
  readonly __externref_table_alloc: () => number;
  readonly __wbindgen_export_2: WebAssembly.Table;
  readonly __wbindgen_malloc: (a: number, b: number) => number;
  readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
  readonly __wbindgen_start: () => void;
}

export type SyncInitInput = BufferSource | WebAssembly.Module;
/**
* Instantiates the given `module`, which can either be bytes or
* a precompiled `WebAssembly.Module`.
*
* @param {{ module: SyncInitInput }} module - Passing `SyncInitInput` directly is deprecated.
*
* @returns {InitOutput}
*/
export function initSync(module: { module: SyncInitInput } | SyncInitInput): InitOutput;

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {{ module_or_path: InitInput | Promise<InitInput> }} module_or_path - Passing `InitInput` directly is deprecated.
*
* @returns {Promise<InitOutput>}
*/
export default function __wbg_init (module_or_path?: { module_or_path: InitInput | Promise<InitInput> } | InitInput | Promise<InitInput>): Promise<InitOutput>;
