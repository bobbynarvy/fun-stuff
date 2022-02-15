const cli = @import("cli.zig");

pub fn main() anyerror!void {
    try cli.run();
}
