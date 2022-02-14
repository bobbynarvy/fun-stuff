const std = @import("std");

const MorseAlpha = struct { char: u8, code: []const u8 };

const MorseAlphaCombinations = [88]MorseAlpha{
    .{ .char = 'A', .code = ".-" },
    .{ .char = 'B', .code = "-..." },
    .{ .char = 'C', .code = "-.-." },
    .{ .char = 'D', .code = "-.." },
    .{ .char = 'E', .code = "." },
    .{ .char = 'F', .code = "..-." },
    .{ .char = 'G', .code = "--." },
    .{ .char = 'H', .code = "...." },
    .{ .char = 'I', .code = ".." },
    .{ .char = 'J', .code = ".---" },
    .{ .char = 'K', .code = "-.-" },
    .{ .char = 'L', .code = ".-.." },
    .{ .char = 'M', .code = "--" },
    .{ .char = 'N', .code = "-." },
    .{ .char = 'O', .code = "---" },
    .{ .char = 'P', .code = ".--." },
    .{ .char = 'Q', .code = "--.-" },
    .{ .char = 'R', .code = ".-." },
    .{ .char = 'S', .code = "..." },
    .{ .char = 'T', .code = "-" },
    .{ .char = 'U', .code = "..-" },
    .{ .char = 'V', .code = "...-" },
    .{ .char = 'W', .code = ".--" },
    .{ .char = 'X', .code = "-..-" },
    .{ .char = 'Y', .code = "-.--" },
    .{ .char = 'Z', .code = "--.." },
    .{ .char = 'a', .code = ".-" },
    .{ .char = 'b', .code = "-..." },
    .{ .char = 'c', .code = "-.-." },
    .{ .char = 'd', .code = "-.." },
    .{ .char = 'e', .code = "." },
    .{ .char = 'f', .code = "..-." },
    .{ .char = 'g', .code = "--." },
    .{ .char = 'h', .code = "...." },
    .{ .char = 'i', .code = ".." },
    .{ .char = 'j', .code = ".---" },
    .{ .char = 'k', .code = "-.-" },
    .{ .char = 'l', .code = ".-.." },
    .{ .char = 'm', .code = "--" },
    .{ .char = 'n', .code = "-." },
    .{ .char = 'o', .code = "---" },
    .{ .char = 'p', .code = ".--." },
    .{ .char = 'q', .code = "--.-" },
    .{ .char = 'r', .code = ".-." },
    .{ .char = 's', .code = "..." },
    .{ .char = 't', .code = "-" },
    .{ .char = 'u', .code = "..-" },
    .{ .char = 'v', .code = "...-" },
    .{ .char = 'w', .code = ".--" },
    .{ .char = 'x', .code = "-..-" },
    .{ .char = 'y', .code = "-.--" },
    .{ .char = 'z', .code = "--.." },
    .{ .char = '1', .code = ".----" },
    .{ .char = '2', .code = "..---" },
    .{ .char = '3', .code = "...--" },
    .{ .char = '4', .code = "....-" },
    .{ .char = '5', .code = "....." },
    .{ .char = '6', .code = "-...." },
    .{ .char = '7', .code = "--..." },
    .{ .char = '8', .code = "---.." },
    .{ .char = '9', .code = "----." },
    .{ .char = '0', .code = "-----" },
    .{ .char = '.', .code = ".-.-.-" },
    .{ .char = ':', .code = "---..." },
    .{ .char = ',', .code = "--..--" },
    .{ .char = ';', .code = "-.-.-" },
    .{ .char = '?', .code = "..--.." },
    .{ .char = '=', .code = "-...-" },
    .{ .char = '\'', .code = ".----." },
    .{ .char = '/', .code = "-..-." },
    .{ .char = '!', .code = "-.-.--" },
    .{ .char = '-', .code = "-....-" },
    .{ .char = '_', .code = "..--.-" },
    .{ .char = '\"', .code = ".-..-." },
    .{ .char = '(', .code = "-.--." },
    .{ .char = ')', .code = "-.--.-" },
    .{ .char = '(', .code = "-.--.-" },
    .{ .char = '$', .code = "...-..-" },
    .{ .char = '&', .code = ".-..." },
    .{ .char = '@', .code = ".--.-." },
    .{ .char = '+', .code = ".-.-." },
    .{ .char = 'Á', .code = ".--.-" },
    .{ .char = 'Ä', .code = ".-.-" },
    .{ .char = 'É', .code = "..-.." },
    .{ .char = 'Ñ', .code = "--.--" },
    .{ .char = 'Ö', .code = "---." },
    .{ .char = 'Ü', .code = "..--" },
    .{ .char = ' ', .code = "/" },
};

pub fn morseAlphaMap(allocator: std.mem.Allocator) !std.AutoHashMap(u8, []const u8) {
    var map = std.AutoHashMap(u8, []const u8).init(allocator);

    for (MorseAlphaCombinations) |value| {
        try map.put(value.char, value.code);
    }

    return map;
}

pub fn alphaMorseMap(allocator: std.mem.Allocator) !std.StringHashMap(u8) {
    var map = std.StringHashMap(u8).init(allocator);

    for (MorseAlphaCombinations) |value| {
        try map.put(value.code, value.char);
    }

    return map;
}
