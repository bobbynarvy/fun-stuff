mod mapping;
mod morse;

fn main() {
    println!("{:?}", morse::encode("hello world!"));
    println!(
        "{:?}",
        morse::decode(".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--")
    );
}
