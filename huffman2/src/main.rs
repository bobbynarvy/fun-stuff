mod encoder;

fn main() {
    let (code, encodings) = encoder::encode(String::from("Hello, world!"));
    println!("{}", code);
}
