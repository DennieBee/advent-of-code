const std = @import("std");
const utils = @import("utils.zig");

pub fn parseAndCalculate(buffer: []u8, handle_do: bool) !void {
    var index: usize = 0;
    var mul_enabled = true;
    var reading_mul = true;
    var reading_left = true;
    var l = std.ArrayList(u8).init(std.heap.page_allocator);
    var r = std.ArrayList(u8).init(std.heap.page_allocator);
    var sum: i64 = 0;
    while (index < buffer.len - 1) {
        if (handle_do and index < buffer.len - 7) {
            if (buffer[index] == 100 and
                buffer[index + 1] == 111 and
                buffer[index + 2] == 40 and
                buffer[index + 3] == 41)
            { //do()
                mul_enabled = true;
            }
            if (buffer[index] == 100 and
                buffer[index + 1] == 111 and
                buffer[index + 2] == 110 and
                buffer[index + 3] == 39 and
                buffer[index + 4] == 116 and
                buffer[index + 5] == 40 and
                buffer[index + 6] == 41)
            { //don't()
                mul_enabled = false;
            }
        }
        if (!mul_enabled) {
            index += 1;
            continue;
        }
        if (reading_mul) {
            if (buffer[index] == 44) { //,
                reading_left = false;
                index += 1;
                continue;
            }
            if (buffer[index] == 41) { //)
                const li = try std.fmt.parseInt(i32, l.items, 10);
                const ri = try std.fmt.parseInt(i32, r.items, 10);
                const result: i32 = li * ri;
                sum += result;
                reading_mul = false;
                index += 1;
                continue;
            }
            if (buffer[index] >= 48 and buffer[index] <= 57) { //numbers
                if (reading_left) {
                    try l.append(buffer[index]);
                } else {
                    try r.append(buffer[index]);
                }
                index += 1;
            } else {
                reading_mul = false;
                index += 1;
            }
        } else {
            if (buffer[index] == 109 and
                buffer[index + 1] == 117 and
                buffer[index + 2] == 108 and
                buffer[index + 3] == 40)
            { //mul()
                reading_mul = true;
                reading_left = true;
                l.clearAndFree();
                r.clearAndFree();
                index += 4;
                continue;
            }
            index += 1;
        }
    }
    std.debug.print("{d}\n", .{sum});
}

pub fn execute() !void {
    const file_name: []const u8 = "day03_input";
    const buffer = try utils.readContents(file_name);
    std.debug.print("Part 1: ", .{});
    try parseAndCalculate(buffer, false);
    std.debug.print("Part 2: ", .{});
    try parseAndCalculate(buffer, true);
}
