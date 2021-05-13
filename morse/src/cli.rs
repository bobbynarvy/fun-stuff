use crate::morse;

use std::env;

pub fn run() {
    let args: Vec<String> = env::args().collect();
    let op = match args.get(1) {
        None => Err("No arguments set"),
        Some(arg) => Ok(arg)
    };
    let s = match args.get(2..) {
        None => Err("Value to encode/decode not set."),
        Some(s) => Ok(s.join(" "))
    };

    let result = op.and_then(|arg| match s {
        Err(e) => Err(e),
        Ok(val) => match arg.as_str() {
            "encode" => Ok(morse::encode(val.as_str())),
            "decode" => Ok(morse::decode(val.as_str())),
            _ => Err("Valid first arguments: encode or decode.")
        }
    });

    println!("{:?}", result)
}