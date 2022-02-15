const std = @import("std");
const morse = @import("morse.zig");
const print = std.debug.print;
const eql = std.mem.eql;

pub fn run() !void {
    var args = std.process.args();

    _ = args.skip();

    if (args.next()) |op| {
        if (!eql(u8, op, "encode") and !eql(u8, op, "decode")) {
            print("error. valid first arguments: 'encode' or 'decode'", .{});
            return;
        }

        while (args.next()) |txt| {
            if (eql(u8, op, "encode")) {
                const message = try morse.encode(txt);
                print("{s} ", .{message});
            } else {
                const message = try morse.decode(txt);
                print("{s}", .{message});
            }
        }
    } else {
        print("Error. No arguments set.", .{});
    }
}
