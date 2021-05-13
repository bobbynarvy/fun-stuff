use std::array;
use std::collections::HashMap;

const MORSE_ALPHA: [(char, &str); 88] = [
    ('A', ".-"),
    ('B', "-..."),
    ('C', "-.-."),
    ('D', "-.."),
    ('E', "."),
    ('F', "..-."),
    ('G', "--."),
    ('H', "...."),
    ('I', ".."),
    ('J', ".---"),
    ('K', "-.-"),
    ('L', ".-.."),
    ('M', "--"),
    ('N', "-."),
    ('O', "---"),
    ('P', ".--."),
    ('Q', "--.-"),
    ('R', ".-."),
    ('S', "..."),
    ('T', "-"),
    ('U', "..-"),
    ('V', "...-"),
    ('W', ".--"),
    ('X', "-..-"),
    ('Y', "-.--"),
    ('Z', "--.."),
    ('a', ".-"),
    ('b', "-..."),
    ('c', "-.-."),
    ('d', "-.."),
    ('e', "."),
    ('f', "..-."),
    ('g', "--."),
    ('h', "...."),
    ('i', ".."),
    ('j', ".---"),
    ('k', "-.-"),
    ('l', ".-.."),
    ('m', "--"),
    ('n', "-."),
    ('o', "---"),
    ('p', ".--."),
    ('q', "--.-"),
    ('r', ".-."),
    ('s', "..."),
    ('t', "-"),
    ('u', "..-"),
    ('v', "...-"),
    ('w', ".--"),
    ('x', "-..-"),
    ('y', "-.--"),
    ('z', "--.."),
    ('1', ".----"),
    ('2', "..---"),
    ('3', "...--"),
    ('4', "....-"),
    ('5', "....."),
    ('6', "-...."),
    ('7', "--..."),
    ('8', "---.."),
    ('9', "----."),
    ('0', "-----"),
    ('.', ".-.-.-"),
    (':', "---..."),
    (',', "--..--"),
    (';', "-.-.-"),
    ('?', "..--.."),
    ('=', "-...-"),
    ('\'', ".----."),
    ('/', "-..-."),
    ('!', "-.-.--"),
    ('-', "-....-"),
    ('_', "..--.-"),
    ('\"', ".-..-."),
    ('(', "-.--."),
    (')', "-.--.-"),
    ('(', "-.--.-"),
    ('$', "...-..-"),
    ('&', ".-..."),
    ('@', ".--.-."),
    ('+', ".-.-."),
    ('Á', ".--.-"),
    ('Ä', ".-.-"),
    ('É', "..-.."),
    ('Ñ', "--.--"),
    ('Ö', "---."),
    ('Ü', "..--"),
    (' ', "/"),
];

pub fn morse_alpha_map() -> HashMap<char, &'static str> {
    array::IntoIter::new(MORSE_ALPHA).collect()
}

pub fn alpha_morse_map() -> HashMap<&'static str, char> {
    array::IntoIter::new(MORSE_ALPHA)
        .map(|(c, s)| (s, c))
        .collect()
}
