use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let name: String = args[1].clone();

    println!("Hello, {}", name);
}
