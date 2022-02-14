const std = @import("std");

const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

const map = @import("mapping.zig");

pub fn encode(message: []const u8) ![]const u8 {
    var mapping = try map.morseAlphaMap(allocator);
    defer mapping.deinit();
    var encoded = ArrayList(u8).init(allocator);

    for (message) |char| {
        if (mapping.get(char)) |code| {
            for (code) |codeChar| {
                try encoded.append(codeChar);
            }
            try encoded.append(' ');
        }
    }

    _ = encoded.pop();

    return encoded.toOwnedSlice();
}

pub fn decode(code: []const u8) ![]u8 {
    var mapping = try map.alphaMorseMap(allocator);
    defer mapping.deinit();
    var chars = ArrayList(u8).init(allocator);
    var iter = std.mem.split(u8, code, " ");

    while (iter.next()) |c| {
        if (mapping.get(c)) |char| {
            try chars.append(char);
        }
    }

    return chars.toOwnedSlice();
}

test "encode" {
    var e = try encode("hello world!");
    defer allocator.free(e);

    try std.testing.expectEqualStrings(e, ".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--");
}

test "decode" {
    var d = try decode(".... . .-.. .-.. --- / .-- --- .-. .-.. -.. -.-.--");
    defer allocator.free(d);

    try std.testing.expectEqualStrings(d, "hello world!");
}
