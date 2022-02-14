const std = @import("std");
const morse = @import("morse.zig");

pub fn main() anyerror!void {
    const code = try morse.encode("hello world!");
    const decode = try morse.decode(code);
    std.debug.print("{s}", .{decode});
}
