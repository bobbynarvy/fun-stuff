const std = @import("std");
const print = std.debug.print;

pub const BinaryTree = struct {
    data: u8,
    left: ?*BinaryTree = null,
    right: ?*BinaryTree = null,
};

fn traverseInorder(node: *BinaryTree) void {
    if (node.left) |left| {
        traverseInorder(left);
    }

    print("{} ", .{node.data});

    if (node.right) |right| {
        traverseInorder(right);
    }

    return;
}

fn traversePreorder(node: *BinaryTree) void {
    print("{} ", .{node.data});

    if (node.left) |left| {
        traversePreorder(left);
    }

    if (node.right) |right| {
        traversePreorder(right);
    }

    return;
}

fn traversePostorder(node: *BinaryTree) void {
    if (node.left) |left| {
        traversePostorder(left);
    }

    if (node.right) |right| {
        traversePostorder(right);
    }

    print("{} ", .{node.data});
    return;
}

pub fn main() void {
    var n1 = BinaryTree{ .data = 1 };
    var n2 = BinaryTree{ .data = 2 };
    var n3 = BinaryTree{ .data = 3 };
    var n4 = BinaryTree{ .data = 4 };
    var n5 = BinaryTree{ .data = 5 };

    n1.left = &n2;
    n1.right = &n3;
    n2.left = &n4;
    n2.right = &n5;

    print("Inorder traversal\n", .{});
    traverseInorder(&n1);
    print("\n", .{});

    print("Preorder traversal\n", .{});
    traversePreorder(&n1);
    print("\n", .{});

    print("Postorder traversal\n", .{});
    traversePostorder(&n1);
    print("\n", .{});
}
