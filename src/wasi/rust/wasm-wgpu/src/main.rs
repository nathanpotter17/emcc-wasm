use wasm_wgpu_w::run;

fn main() {
    pollster::block_on(run());
}