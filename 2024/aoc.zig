const std = @import("std");

const day01 = @import("day01.zig");
const day02 = @import("day02.zig");
const day03 = @import("day03.zig");

pub fn main() !void {
    std.debug.print("Day 1: \n", .{});
    try day01.execute();
    std.debug.print("\nDay 2: \n", .{});
    try day02.execute();
    std.debug.print("\nDay 3: \n", .{});
    try day03.execute();
}
