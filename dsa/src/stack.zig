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

// implement a stack using an array
pub fn ArrayStack(comptime T: type, comptime N: usize) type {
    return struct {
        const Self = @This();

        pub const StackError = error{ StackFull, StackEmpty };

        array: [N]T = [_]T{0} ** N,
        size: usize = 0,

        pub fn push(self: *Self, item: T) !void {
            if (self.size + 1 > N) {
                return StackError.StackFull;
            }

            self.size = self.size + 1;
            self.array[self.size - 1] = item;
        }

        pub fn pop(self: *Self) !T {
            if (self.size == 0) {
                return StackError.StackEmpty;
            }

            const item = self.array[self.size - 1];
            self.size = self.size - 1;

            return item;
        }
    };
}

const A = ArrayStack(u8, 3);

test "push to a stack" {
    var stack = A{};

    try stack.push(32);
    try testing.expect(stack.size == 1);

    try stack.push(89);
    try testing.expect(stack.size == 2);
}

test "push to a full stack" {
    var stack = A{};

    try stack.push(32);
    try stack.push(89);
    try stack.push(55);
    var err = stack.push(63);

    try testing.expectError(A.StackError.StackFull, err);
}

test "pop a stack" {
    var stack = A{};

    try stack.push(32);
    try stack.push(89);
    try stack.push(55);

    var item = try stack.pop();
    try testing.expect(item == 55);
    try testing.expect(stack.size == 2);

    item = try stack.pop();
    try testing.expect(item == 89);
    try testing.expect(stack.size == 1);

    item = try stack.pop();
    try testing.expect(item == 32);
    try testing.expect(stack.size == 0);
}

test "pop an empty stack" {
    var stack = A{};

    var err = stack.pop();

    try testing.expectError(A.StackError.StackEmpty, err);
}
