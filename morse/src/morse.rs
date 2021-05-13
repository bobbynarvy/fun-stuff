use crate::mapping;

pub fn encode(message: &str) -> String {
    let mapping = mapping::morse_alpha_map();
    let mut encoded = message.chars().fold(String::new(), |mut s, c| {
        let d = match mapping.get(&c) {
            None => "",
            Some(ch) => ch,
        };

        s.push_str(d);
        s.push_str(" ");
        s
    });

    // remove last space
    encoded.pop();

    encoded
}

pub fn decode(code: &str) -> String {
    let mapping = mapping::alpha_morse_map();
    code.split(' ').fold(String::new(), |mut s, symbol| {
        match mapping.get(symbol) {
            None => (),
            Some(ch) => s.push(*ch),
        };

        s
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn encode_works() {
        let m = "hello world!";
        let e = encode(m);
        assert_eq!(e, ".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--");
    }

    #[test]
    fn decode_works() {
        let c = ".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--";
        let d = decode(c);
        assert_eq!(d, "hello world!");
    }
}
