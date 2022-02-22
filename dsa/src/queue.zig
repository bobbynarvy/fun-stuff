const std = @import("std");
const testing = std.testing;

pub fn Queue(comptime T: type, comptime N: usize) type {
    return struct {
        const Self = @This();
        pub const QueueError = error{ QueueFull, QueueEmpty };

        _arr: [N]T = [_]T{0} ** N,
        size: usize = 0,
        front: usize = 0,
        rear: usize = N - 1,

        pub fn enqueue(self: *Self, item: T) !void {
            if (self.size == N) return QueueError.QueueFull;

            self.rear = (self.rear + 1) % N;
            self._arr[self.rear] = item;
            self.size += 1;
        }

        pub fn dequeue(self: *Self) !T {
            if (self.size == 0) return QueueError.QueueEmpty;

            var item = self._arr[self.front];
            self.front = (self.front + 1) % N;
            self.size -= 1;

            return item;
        }
    };
}

const Q = Queue(u8, 3);

test "enqueue items" {
    var q = Q{};

    try q.enqueue(1);
    try q.enqueue(2);
    try q.enqueue(3);

    try testing.expect(q.size == 3);
}

test "enqueue too many items" {
    var q = Q{};

    try q.enqueue(1);
    try q.enqueue(2);
    try q.enqueue(3);
    var err = q.enqueue(4);

    try testing.expectError(Q.QueueError.QueueFull, err);
}

test "dequeue items" {
    var q = Q{};

    try q.enqueue(1);
    try q.enqueue(2);
    try q.enqueue(3);

    var item = try q.dequeue();
    try testing.expect(item == 1);
    item = try q.dequeue();
    try testing.expect(item == 2);
    item = try q.dequeue();
    try testing.expect(item == 3);
}

test "dequeue too many items" {
    var q = Q{};

    try q.enqueue(1);

    _ = try q.dequeue();
    var err = q.dequeue();

    try testing.expectError(Q.QueueError.QueueEmpty, err);
}

test "queue and dequeue items" {
    var q = Q{};

    try q.enqueue(1);
    try q.enqueue(2);

    var item = try q.dequeue();
    try testing.expect(item == 1);

    try q.enqueue(3);
    try q.enqueue(4);

    item = try q.dequeue();
    try testing.expect(item == 2);
    item = try q.dequeue();
    try testing.expect(item == 3);

    try q.enqueue(5);

    item = try q.dequeue();
    try testing.expect(item == 4);
    item = try q.dequeue();
    try testing.expect(item == 5);

    try testing.expect(q.size == 0);
}
