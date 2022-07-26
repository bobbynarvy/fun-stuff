const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const test_alloc = std.testing.allocator;
const expect = std.testing.expect;

const Node = struct { count: i8, char: ?u8, left: ?*Node, right: ?*Node };

fn initNodes(text: []const u8, alloc: Allocator) !ArrayList(Node) {
    var char_counts = std.AutoHashMap(u8, i8).init(alloc);
    defer char_counts.deinit();
    var nodes = ArrayList(Node).init(alloc);

    for (text) |char| {
        var entry = try char_counts.getOrPutValue(char, 0);
        entry.value_ptr.* += 1;
    }

    var iterator = char_counts.iterator();
    while (iterator.next()) |char_count| {
        const node = Node{ .count = char_count.value_ptr.*, .char = char_count.key_ptr.*, .left = null, .right = null };
        try nodes.append(node);
    }

    return nodes;
}

fn createLeafNode(char: u8, count: i8) Node {
    return Node{ .count = count, .char = char, .left = null, .right = null };
}

fn mergeNodes(left: *Node, right: *Node) Node {
    return Node{ .count = left.count + right.count, .char = null, .left = left, .right = right };
}

fn cmpByCount(_: void, lhs: Node, rhs: Node) bool {
    if (lhs.count < rhs.count) {
        return false;
    } else {
        return true;
    }
}

fn createTree(nodes: *ArrayList(Node), alloc: Allocator) Node {
    var items = nodes.toOwnedSlice();
    defer alloc.free(items);
    while (items.len > 1) {
        std.sort.sort(Node, items, {}, cmpByCount);

        var left = items[items.len - 1];
        items.len -= 1;
        var right = items[items.len - 1];

        const new_node = mergeNodes(&left, &right);
        items[items.len - 1] = new_node;
    }

    return items[items.len - 1];
}

test "initNodes" {
    var nodes = try initNodes("Hello", test_alloc);
    defer nodes.deinit();

    try expect(nodes.items.len == 4);
}

test "createTree" {
    const left = createLeafNode('a', 1);
    const right = createLeafNode('b', 2);
    var nodes = ArrayList(Node).init(test_alloc);
    try nodes.append(left);
    try nodes.append(right);
    const tree = createTree(&nodes, test_alloc);

    try expect(tree.count == 3);

    if (tree.left) |node| {
        if (node.char) |c| {
            try expect(c == 'a');
        }
    }

    if (tree.right) |node| {
        if (node.char) |c| {
            try expect(c == 'b');
        }
    }
}
