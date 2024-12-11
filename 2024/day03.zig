const std = @import("std");
const utils = @import("utils.zig");

pub fn parseAndCalculate(buffer: []u8) !void {
    var index: usize = 0;
    var readingMul = true;
    var readingLeft = true;
    var l = std.ArrayList(u8).init(std.heap.page_allocator);
    var r = std.ArrayList(u8).init(std.heap.page_allocator);
    var sum: i64 = 0;
    while (index < buffer.len - 1) {
        if (readingMul) {
            if (buffer[index] == 44) {
                readingLeft = false;
                index += 1;
                continue;
            }
            if (buffer[index] == 41) { //)
                const li = try std.fmt.parseInt(i32, l.items, 10);
                const ri = try std.fmt.parseInt(i32, r.items, 10);
                const result: i32 = li * ri;
                sum += result;
                readingMul = false;
                index += 1;
                continue;
            }
            if (buffer[index] >= 48 and buffer[index] <= 57) {
                if (readingLeft) {
                    try l.append(buffer[index]);
                } else {
                    try r.append(buffer[index]);
                }
                index += 1;
            } else {
                readingMul = false;
                index += 1;
            }
        } else {
            if (buffer[index] == 109) { //m
                if (buffer[index + 1] == 117 and buffer[index + 2] == 108 and buffer[index + 3] == 40) { //ul(
                    readingMul = true;
                    readingLeft = true;
                    l.clearAndFree();
                    r.clearAndFree();
                    index += 4;
                    continue;
                }
            }
            index += 1;
        }
    }
    std.debug.print("Part 1: {d}", .{sum});
}

pub fn execute() !void {
    const file_name: []const u8 = "day03_input";
    const buffer = try utils.readContents(file_name);
    try parseAndCalculate(buffer);
}
