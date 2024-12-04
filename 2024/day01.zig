const std = @import("std");

pub fn readContents(file_name: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var buffered_reader = std.io.bufferedReader(file.reader());
    const reader = buffered_reader.reader();
    const file_size = (try file.stat()).size;

    const buffer = try std.heap.page_allocator.alloc(u8, file_size);
    try reader.readNoEof(buffer);

    return buffer;
}

pub fn main() !void {
    var list1: [1000]i32 = undefined;
    var list2: [1000]i32 = undefined;

    const file_name: []const u8 = "day01_input";
    const buffer = try readContents(file_name);

    var location_id: [5]u8 = undefined;
    var first_list = true;
    var place_index: usize = 0;
    var list_index: usize = 0;

    var pos: usize = 0;
    while (pos < buffer.len) {
        const character = buffer[pos];

        if (character >= 48 and character <= 57) {
            location_id[place_index] = character;
            place_index += 1;
        }

        if (character == 32 or character == 10) {
            const integer = try std.fmt.parseInt(i32, &location_id, 10);
            if (first_list) list1[list_index] = integer else list2[list_index] = integer;
            location_id = undefined;

            if (character == 32) {
                first_list = false;
                place_index = 0;
                pos += 3;
            } else {
                first_list = true;
                place_index = 0;
                list_index += 1;
                pos += 1;
            }
            continue;
        }

        pos += 1;
    }

    std.mem.sort(i32, &list1, {}, std.sort.asc(i32));
    std.mem.sort(i32, &list2, {}, std.sort.asc(i32));

    // Part 1
    var index: usize = 0;
    var distance_sum: i32 = 0;
    while (index < list1.len) {
        const first = list1[index];
        const second = list2[index];
        var distance = first - second;
        if (distance < 0) distance = distance * -1;
        distance_sum += distance;
        index += 1;
    }
    std.debug.print("part 1: {d}\n", .{distance_sum});

    // Part 2
    var similarity_sum: i32 = 0;
    for (list1) |list1_value| {
        var count_similar: i32 = 0;
        for (list2) |list2_value| {
            if (list1_value == list2_value) count_similar += 1;
        }
        similarity_sum += list1_value * count_similar;
        index += 1;
    }
    std.debug.print("part 2: {d}\n", .{similarity_sum});
}
