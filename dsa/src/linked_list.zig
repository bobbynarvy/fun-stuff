const std = @import("std");
const testing = std.testing;

fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const Node = struct {
            data: T,
            next: ?*Node,
        };

        head: ?*Node,
        end: ?*Node,

        pub fn init() Self {
            return Self{ .head = null, .end = null };
        }

        pub fn push(self: *Self, data: T) void {
            if (self.head) |head| {
                const next = head;
                self.head = &Node{
                    .data = data,
                    .next = next,
                };
            } else {
                var node = Node{ .data = data, .next = null };
                self.head = &node;
                self.end = &node;
            }
        }

        pub fn insertAfter(self: *Self, node: *Node, data: T) void {
            if (node.next) |next| {
                const tmp = next;
                node.next = &Node{
                    .data = data,
                    .next = tmp,
                };
            } else {
                var new_node = Node{ .data = data, .next = null };
                node.next = &new_node;
                self.end = &new_node;
            }
        }

        pub fn append(self: *Self, data: T) void {
            if (self.end) |end| {
                const tmp = end;
                var new_node = Node{ .data = data, .next = null };
                self.end = &new_node;
                tmp.next = &new_node;
            } else {
                self.push(data);
            }
        }
    };
}

test "push to empty list" {
    var list = LinkedList(u8).init();
    list.push(77);
    try testing.expect(list.head.?.*.data == 77);
    try testing.expect(list.end.?.*.data == 77);
}

test "push to non-empty list" {
    var list = LinkedList(u8).init();
    list.push(77);
    list.push(88);
    try testing.expect(list.head.?.*.data == 88);
    try testing.expect(list.end.?.*.data == 77);
}

test "insert after node" {
    var list = LinkedList(u8).init();
    list.push(77);
    list.push(88);

    var node = list.head.?;

    try testing.expect(node.next.?.*.data == 77);
    list.insertAfter(node, 99);
    try testing.expect(node.next.?.*.data == 99);
}

test "insert after the end node" {
    var list = LinkedList(u8).init();
    list.push(77);

    var node = list.head.?;

    list.insertAfter(node, 99);
    try testing.expect(list.end == node.next.?);
}

test "append to empty list" {
    var list = LinkedList(u8).init();
    list.append(77);
    try testing.expect(list.head.?.*.data == 77);
    try testing.expect(list.end.?.*.data == 77);
}

test "append to non-empty list" {
    var list = LinkedList(u8).init();
    list.push(77);
    list.append(88);
    try testing.expect(list.head.?.*.data == 77);
    try testing.expect(list.end.?.*.data == 88);
}
