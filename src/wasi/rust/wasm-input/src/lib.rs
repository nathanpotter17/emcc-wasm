use wasm_bindgen::prelude::*;
use web_sys::{HtmlCanvasElement, CanvasRenderingContext2d};

#[wasm_bindgen]
pub struct Game {
    x: f64,
    y: f64,
    speed: f64,
}

#[wasm_bindgen]
impl Game {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Game {
        Game {
            x: 50.0,
            y: 50.0,
            speed: 5.0,
        }
    }

    pub fn update(&mut self, keys: Vec<String>) {
        if keys.contains(&"w".to_string()) {
            self.y -= self.speed;
        }
        if keys.contains(&"s".to_string()) {
            self.y += self.speed;
        }
        if keys.contains(&"a".to_string()) {
            self.x -= self.speed;
        }
        if keys.contains(&"d".to_string()) {
            self.x += self.speed;
        }
    }

    pub fn draw(&self) {
        let window = web_sys::window().unwrap();
        let document = window.document().unwrap();
        let canvas = document
            .get_element_by_id("canvas")
            .unwrap()
            .dyn_into::<HtmlCanvasElement>()
            .unwrap();
        let context = canvas
            .get_context("2d")
            .unwrap()
            .unwrap()
            .dyn_into::<CanvasRenderingContext2d>()
            .unwrap();

        context.clear_rect(0.0, 0.0, 800.0, 600.0);
        context.set_fill_style(&JsValue::from_str("blue"));
        context.fill_rect(self.x, self.y, 50.0, 50.0);
    }
}
