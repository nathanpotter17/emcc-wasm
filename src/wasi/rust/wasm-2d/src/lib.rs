use wasm_bindgen::prelude::*;
use web_sys::{HtmlCanvasElement, CanvasRenderingContext2d};

#[wasm_bindgen]
pub struct Game {
    x: f64,
    y: f64,
    velocity_y: f64,
    speed: f64,
    gravity: f64,
    scene: SceneManager,
    on_ground: bool,
    jump_count: u8,
}


#[wasm_bindgen]
impl Game {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Game {
        let mut scene = SceneManager::new();
        scene.add_obstacle(0.0, 680.0, 1280.0, 10.0);
        scene.add_obstacle(300.0, 650.0, 150.0, 10.0);
        scene.add_obstacle(600.0, 655.0, 150.0, 10.0);

        Game {
            x: 100.0,
            y: 600.0,
            velocity_y: 0.0,
            speed: 5.0,
            gravity: 0.5,
            scene,
            on_ground: false,
            jump_count: 0,
        }
    }

    pub fn update(&mut self, keys: Vec<String>) {
        let mut new_x = self.x;
        let mut new_y = self.y;

        if keys.contains(&"a".to_string()) {
            new_x -= self.speed;
        }
        if keys.contains(&"d".to_string()) {
            new_x += self.speed;
        }

        if !self.scene.is_colliding(new_x, self.y, 50.0, 50.0) {
            self.x = new_x;
        }

        self.velocity_y += self.gravity;
        new_y += self.velocity_y;

        if self.scene.is_colliding(self.x, new_y, 50.0, 50.0) {
            self.y = new_y - self.velocity_y;
            self.velocity_y = 0.0;
            self.on_ground = true;
            self.jump_count = 0;
        } else {
            self.y = new_y;
            self.on_ground = false;
        }
        
        if self.x < 0.0 {
            self.x = 0.0;
        }
        if self.x > 1230.0 {
            self.x = 1230.0;
        }
        if self.y > 680.0 {
            self.y = 680.0;
            self.velocity_y = 0.0;
        }

        if keys.contains(&"w".to_string()) {
            if self.on_ground {
                self.velocity_y = -10.0;
                self.jump_count = 1;
            } else if self.jump_count == 1 {
                continue; // do nothing, already jumped once
            }
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

        context.clear_rect(0.0, 0.0, 1280.0, 720.0);

        context.set_fill_style(&JsValue::from_str("blue"));
        context.fill_rect(self.x, self.y, 50.0, 50.0);

        self.scene.draw(&context);
    }
}

#[wasm_bindgen]
pub struct SceneManager {
    obstacles: Vec<Obstacle>,
}

#[wasm_bindgen]
impl SceneManager {
    pub fn new() -> SceneManager {
        SceneManager { obstacles: vec![] }
    }

    pub fn add_obstacle(&mut self, x: f64, y: f64, width: f64, height: f64) {
        self.obstacles.push(Obstacle { x, y, width, height });
    }

    pub fn is_colliding(&self, x: f64, y: f64, width: f64, height: f64) -> bool {
        for obstacle in &self.obstacles {
            if x < obstacle.x + obstacle.width
                && x + width > obstacle.x
                && y < obstacle.y + obstacle.height
                && y + height > obstacle.y
            {
                return true;
            }
        }
        false
    }

    pub fn draw(&self, context: &CanvasRenderingContext2d) {
        context.set_fill_style(&JsValue::from_str("lightblue"));
        for obstacle in &self.obstacles {
            context.fill_rect(obstacle.x, obstacle.y, obstacle.width, obstacle.height);
        }
    }
}

#[wasm_bindgen]
pub struct Obstacle {
    x: f64,
    y: f64,
    width: f64,
    height: f64,
}
