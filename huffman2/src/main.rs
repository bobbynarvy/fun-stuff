mod decoder;
mod encoder;

fn main() {
    let (mut code, encodings) = encoder::encode(String::from("Hello, world!"));
    let decoded = decoder::decode(code, encodings);
    println!("{}", decoded);
}
