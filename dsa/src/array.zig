const std = @import("std");
const testing = @import("std").testing;

fn rotate(comptime n: u8, array: *[n]u8, d: u8) void {
    var tmp_array = [_]u8{0} ** n;

    for (array) |*elem, i| {
        const diff: i8 = @intCast(i8, i) - @intCast(i8, d);
        if (diff < 0) {
            tmp_array[n - d + @intCast(u8, i)] = elem.*;
        } else {
            tmp_array[@intCast(u8, i) - d] = elem.*;
        }
    }

    for (tmp_array) |*elem, i| {
        array[i] = elem.*;
    }
}

fn reverse(comptime n: u8, array: *[n]u8) void {
    var temp: u8 = undefined;
    var start: usize = 0;
    var end: usize = n - 1;

    while (start < end) : ({
        start += 1;
        end -= 1;
    }) {
        temp = array[start];
        array[start] = array[end];
        array[end] = temp;
    }
}

test "rotate" {
    var array = [7]u8{ 1, 2, 3, 4, 5, 6, 7 };

    rotate(array.len, &array, 2);

    try testing.expectEqual(array, [_]u8{ 3, 4, 5, 6, 7, 1, 2 });
}

test "reverse" {
    var array = [7]u8{ 1, 2, 3, 4, 5, 6, 7 };

    reverse(array.len, &array);

    try testing.expectEqual(array, [_]u8{ 7, 6, 5, 4, 3, 2, 1 });
}
