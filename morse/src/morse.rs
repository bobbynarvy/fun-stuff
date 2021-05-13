use crate::mapping::morse_alpha_map;

pub fn encode(message: &str) -> String {
    let mapping = morse_alpha_map();
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn encode_works() {
        let m = "hello world!";
        let e = encode(m);
        assert_eq!(e, ".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--");
    }
}
