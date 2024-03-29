const std = @import("std");
const testing = std.testing;

fn LinkedList(comptime T: type) type {
    return struct {
        const Self = @This();
        pub const Node = struct {
            data: T,
            next: ?*Node = null,

            pub fn insertAfter(self: *Node, node: *Node) void {
                node.next = self.next;
                self.next = node;
            }

            pub fn countChildren(self: *Node) usize {
                var cnt: usize = 1;
                var next_node = self.next;

                while (next_node) |node| : (next_node = node.next) {
                    cnt += 1;
                }

                return cnt;
            }
        };

        head: ?*Node = null,

        pub fn init() Self {
            return Self{ .head = null };
        }

        pub fn push(self: *Self, node: *Node) void {
            node.next = self.head;
            self.head = node;
        }

        pub fn append(self: *Self, node: *Node) void {
            if (self.head) |head| {
                var current: *Node = head;

                while (current.next != null) {
                    current = current.next.?;
                }

                current.next = node;
            } else {
                self.head = node;
            }
        }

        pub fn delete(self: *Self, node: *Node) void {
            if (self.head) |head| {
                var current: *Node = head;

                if (current == node) {
                    self.head = current.next;
                    return;
                }

                while (current.next != node) {
                    current = current.next.?;
                }

                current.next = node.next;
            }
        }

        pub fn count(self: *Self) usize {
            if (self.head == null) return 0;

            return self.head.?.countChildren();
        }
    };
}

const List = LinkedList(u8);

test "push to empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };

    list.push(&n1);

    try testing.expect(list.head == &n1);
}

test "push to non-empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };
    var n2 = List.Node{ .data = 88 };

    list.push(&n1);
    list.push(&n2);

    try testing.expect(list.head == &n2);
}

test "insert after node" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };
    var n2 = List.Node{ .data = 88 };
    var n3 = List.Node{ .data = 99 };

    list.push(&n1);
    list.push(&n2);

    var node = list.head.?;

    try testing.expect(node.next == &n1);

    n2.insertAfter(&n3);

    try testing.expect(node.next == &n3);
    try testing.expect(n3.next == &n1);
}

test "append to empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };

    list.append(&n1);

    try testing.expect(list.head == &n1);
}

test "append to non-empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };
    var n2 = List.Node{ .data = 88 };
    var n3 = List.Node{ .data = 99 };

    list.append(&n1);
    list.append(&n2);
    list.append(&n3);

    var head = list.head.?;
    try testing.expect(head == &n1);
    try testing.expect(head.next == &n2);
    try testing.expect(head.next.?.next == &n3);
}

test "delete node in non-empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };
    var n2 = List.Node{ .data = 88 };
    var n3 = List.Node{ .data = 99 };

    list.append(&n1);
    list.append(&n2);
    list.append(&n3);
    list.delete(&n2);

    var head = list.head.?;
    try testing.expect(head == &n1);
    try testing.expect(head.next == &n3);
}

test "delete head in non-empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };
    var n2 = List.Node{ .data = 88 };
    var n3 = List.Node{ .data = 99 };

    list.append(&n1);
    list.append(&n2);
    list.append(&n3);
    list.delete(&n1);

    var head = list.head.?;
    try testing.expect(head == &n2);
    try testing.expect(head.next == &n3);
}

test "delete node in empty list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };

    list.delete(&n1);

    try testing.expect(list.head == null);
}

test "count list" {
    var list = List.init();
    var n1 = List.Node{ .data = 77 };
    var n2 = List.Node{ .data = 88 };
    var n3 = List.Node{ .data = 99 };

    list.append(&n1);
    list.append(&n2);
    list.append(&n3);

    try testing.expect(list.count() == 3);
}
