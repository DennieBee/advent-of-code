const std = @import("std");

pub fn read_contents(file_name: []const u8) ![]u8 {
    const file = try std.fs.cwd().openFile(file_name, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader();
    const file_size = (try file.stat()).size;

    const buffer = try std.heap.page_allocator.alloc(u8, file_size);
    try in_stream.readNoEof(buffer);

    return buffer;
}

pub fn main() !void {
    const file_name: []const u8 = "day01_input";
    const buffer = try read_contents(file_name);
    std.debug.print("{s}", .{buffer});
}
