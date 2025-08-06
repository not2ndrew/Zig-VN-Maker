const std = @import("std");
const rl = @import("raylib");

pub const ButtonVisual = struct {
    label: [:0]const u8,
    x_position: i32,
    y_position: i32,
    x_padding: i32,
    y_padding: i32,
    font_size: i32,
};

pub const ButtonInteractive = struct {
    hovered: bool,
    clicked: bool,
};

pub const ButtonBehaviour = *const fn() void;
