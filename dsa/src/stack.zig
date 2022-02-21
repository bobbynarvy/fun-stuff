const std = @import("std");
const testing = std.testing;

// implement a stack using a linked list
pub fn Stack(comptime T: type) type {
    return struct {
        const Self = @This();

        pub const Node = struct { data: T, next: ?*Node = null };

        top: ?*Node = null,

        pub fn push(self: *Self, node: *Node) void {
            node.next = self.top;
            self.top = node;
        }

        pub fn pop(self: *Self) ?*Node {
            if (self.top) |top| {
                self.top = top.next;
                return top;
            }

            return null;
        }
    };
}

const S = Stack(u8);

test "push to a stack" {
    var stack = S{};
    var n1 = S.Node{ .data = 32 };
    var n2 = S.Node{ .data = 89 };

    stack.push(&n1);
    try testing.expect(stack.top == &n1);

    stack.push(&n2);
    try testing.expect(stack.top == &n2);
}

test "pop a stack" {
    var stack = S{};
    var n1 = S.Node{ .data = 32 };
    var n2 = S.Node{ .data = 89 };

    stack.push(&n1);
    stack.push(&n2);

    var top = stack.pop();
    try testing.expect(top == &n2);

    top = stack.pop();
    try testing.expect(top == &n1);

    top = stack.pop();
    try testing.expect(top == null);
}
