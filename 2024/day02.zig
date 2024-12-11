const std = @import("std");
const utils = @import("utils.zig");

pub fn abs(number: i32) i32 {
    if (number < 0) return -number;
    return number;
}

pub fn clearReport(report: []i32) !void {
    var index: usize = 0;
    while (index < report.len) {
        report[index] = -1;
        index += 1;
    }
}

pub fn dampenReport(report: []i32, damped_element: usize) ![]i32 {
    var dampened_report = try std.heap.page_allocator.alloc(i32, 10);
    try clearReport(dampened_report);
    var index: usize = 0;
    while (index < report.len - 1) {
        if (index >= damped_element) {
            dampened_report[index] = report[index + 1];
        } else {
            dampened_report[index] = report[index];
        }
        index += 1;
    }
    return dampened_report;
}

pub fn testReport(report: []i32, use_damping: bool) !bool {
    var ascending = true;
    var index: usize = 0;
    var safe = true;
    var iteration: usize = 0;
    var iterations: usize = 1;
    var test_report = report;

    if (use_damping) iterations = 10;

    while (iteration < iterations) {
        safe = true;
        index = 0;

        if (use_damping) {
            const dampened_report = try dampenReport(report, iteration);
            test_report = dampened_report;
        }

        while (index < test_report.len) {
            if (test_report[index] > -1) {
                if (index == 0) {
                    if (test_report[index + 1] < test_report[index]) {
                        ascending = false;
                    }
                } else {
                    if (test_report[index - 1] == test_report[index]) {
                        safe = false;
                    }
                    if (ascending) {
                        if (test_report[index - 1] > test_report[index]) {
                            safe = false;
                        }
                    } else {
                        if (test_report[index - 1] < test_report[index]) {
                            safe = false;
                        }
                    }
                    if (abs(test_report[index - 1] - test_report[index]) > 3) {
                        safe = false;
                    }
                }
            }
            index += 1;
        }
        iteration += 1;

        if (safe) {
            break;
        }
    }

    return safe;
}

pub fn parse(buffer: []u8) !void {
    var report: [10]i32 = undefined;
    try clearReport(&report);

    var index: usize = 0;
    var current_level: [2]u8 = undefined;
    var current_level_index: usize = 0;
    var level_index: usize = 0;
    var safe_reports: i32 = 0;
    var safe_reports_with_dampening: i32 = 0;
    while (index < buffer.len - 1) {
        if (buffer[index] >= 48 and buffer[index] <= 57) {
            current_level[current_level_index] = buffer[index];
        }

        if (buffer[index + 1] == 32 or buffer[index + 1] == 13) {
            if (current_level_index == 0) {
                current_level[1] = current_level[0];
                current_level[0] = 48;
            }

            report[level_index] = try std.fmt.parseInt(i32, &current_level, 10);

            if (buffer[index + 1] == 13) {
                const result = try testReport(&report, false);
                if (result) safe_reports += 1;

                const result_with_dampening = try testReport(&report, true);
                if (result_with_dampening) safe_reports_with_dampening += 1;

                level_index = 0;
                try clearReport(&report);
                index += 3;
            } else {
                level_index += 1;
                index += 2;
            }

            current_level_index = 0;
            current_level[0] = 48;
            current_level[1] = 48;
        } else {
            current_level_index += 1;
            index += 1;
        }
    }

    std.debug.print("Part 1: {d}\n", .{safe_reports});
    std.debug.print("Part 2: {d}\n", .{safe_reports_with_dampening});
}

pub fn execute() !void {
    const file_name: []const u8 = "day02_input";
    const buffer = try utils.readContents(file_name);
    try parse(buffer);
}
