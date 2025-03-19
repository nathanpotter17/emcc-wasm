use wasm_bindgen::prelude::*;

// structs
#[wasm_bindgen]
pub struct Facts {
    pub count: u32,
}

// internal method
#[wasm_bindgen]
pub fn test_string(s: &str) -> Facts {
    let count = s.chars().count() as u32;
    Facts { count }
}

// The utf-8 string provided is copied to the JS heap and the string will be owned by the JS garbage collector.
#[wasm_bindgen]
pub fn see_string() -> JsValue {
    let test_str = "Hello, from Rust!";
    JsValue::from_str(test_str)
}

// Call JS Methods, like Set on an Object. Return JsValue
#[wasm_bindgen]
pub fn invoke_test_string() -> JsValue {
    let test_str = "Hello, WebAssembly!";
    let facts = test_string(test_str);

    // Create a new object from inside Rust
    let js_object = js_sys::Object::new();
    
    // Set the 'count' property
    js_sys::Reflect::set(&js_object, &JsValue::from_str("count"), &JsValue::from_f64(facts.count as f64)).unwrap();
    
    // Set another property: 'message'
    let message = format!("The message is: {}", test_str);
    js_sys::Reflect::set(&js_object, &JsValue::from_str("message"), &JsValue::from_str(&message)).unwrap();
    
    // Set a third property: 'is_valid'
    js_sys::Reflect::set(&js_object, &JsValue::from_str("is_valid"), &JsValue::from_bool(true)).unwrap();

    // Return the object to JavaScript
    js_object.into()
}
