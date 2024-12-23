const std = @import("std");
const utils = @import("utils.zig");

pub fn execute() !void {
    const size: usize = 142;
    const file_name: []const u8 = "day04_input";
    const buffer = try utils.readContents(file_name);
    var xmasses: i32 = 0;
    var masses: i32 = 0;
    var index: usize = 0;
    while (index < buffer.len) {
        //horfor
        if (index + 3 < buffer.len and buffer[index] == 88 and buffer[index + 1] == 77 and buffer[index + 2] == 65 and buffer[index + 3] == 83) xmasses += 1;
        //horback
        if (index > 3 and buffer[index] == 88 and buffer[index - 1] == 77 and buffer[index - 2] == 65 and buffer[index - 3] == 83) xmasses += 1;
        //vertfor
        if (index + 3 * size < buffer.len and buffer[index] == 88 and buffer[index + size] == 77 and buffer[index + 2 * size] == 65 and buffer[index + 3 * size] == 83) xmasses += 1;
        //vertback
        if (index >= 3 * size and buffer[index] == 88 and buffer[index - size] == 77 and buffer[index - 2 * size] == 65 and buffer[index - 3 * size] == 83) xmasses += 1;
        //curlrfor
        if ((index + 3) + (3 * size) < buffer.len and buffer[index] == 88 and buffer[index + 1 + size] == 77 and buffer[(index + 2) + 2 * size] == 65 and buffer[(index + 3) + 3 * size] == 83) xmasses += 1;
        //curlrback
        if (index >= 3 + 3 * size and buffer[index] == 88 and buffer[index - 1 - size] == 77 and buffer[(index - 2) - 2 * size] == 65 and buffer[(index - 3) - 3 * size] == 83) xmasses += 1;
        //currlfor
        if (index > 3 and index + (3 * size) < buffer.len and buffer[index] == 88 and buffer[index - 1 + size] == 77 and buffer[(index - 2) + 2 * size] == 65 and buffer[(index - 3) + 3 * size] == 83) xmasses += 1;
        //currlback
        if (index >= (3 * size) and buffer[index] == 88 and buffer[index + 1 - size] == 77 and buffer[(index + 2) - 2 * size] == 65 and buffer[(index + 3) - 3 * size] == 83) xmasses += 1;

        if (index >= size + 1 and index + size + 1 < buffer.len and buffer[index] == 65) {
            const tl = buffer[index - 1 - size];
            const tr = buffer[index + 1 - size];
            const bl = buffer[index - 1 + size];
            const br = buffer[index + 1 + size];
            var p1 = false;
            var p2 = false;
            if (tl == 77 and br == 83) p1 = true;
            if (tl == 83 and br == 77) p1 = true;
            if (bl == 77 and tr == 83) p2 = true;
            if (bl == 83 and tr == 77) p2 = true;
            if (p1 and p2) masses += 1;
        }

        index += 1;
    }
    std.debug.print("Part 1: {d}\n", .{xmasses});
    std.debug.print("Part 2: {d}\n", .{masses});
}
