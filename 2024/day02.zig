const utils = @import("utils.zig");

pub fn execute() !void {
    const file_name: []const u8 = "day02_input";
    const buffer = try utils.readContents(file_name);
    _ = buffer;
}
