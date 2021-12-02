type Encoding = (char, String);

pub fn decode(mut code: String, encodings: Vec<Encoding>) -> String {
    let mut decoded = String::from("");

    while code.len() > 0 {
        for (c, encoding) in &encodings {
            let sub: String = code.chars().take(encoding.len()).collect();
            if sub == *encoding {
                decoded.push(*c);
                code.drain(..encoding.len());
            }
        }
    }

    decoded
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_decode() {
        let mut code = String::from("001010011111");
        let encodings = vec![
            ('e', String::from("11")),
            ('m', String::from("001")),
            ('o', String::from("010")),
            ('r', String::from("0111")),
        ];

        assert_eq!(decode(code, encodings), "more");
    }
}
