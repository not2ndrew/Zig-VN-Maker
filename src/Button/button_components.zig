const std = @import("std");

pub const ButtonCallBack = *const fn () void;

pub const ButtonManager = struct {
    visuals: std.ArrayList(ButtonVisual) = undefined,
    interactives: std.ArrayList(ButtonInteractive) = undefined,
    behaviours: std.ArrayList(ButtonBehaviour) = undefined,

    pub fn init(self: *ButtonManager, allocator: std.mem.Allocator) void {
        self.visuals = std.ArrayList(ButtonVisual).init(allocator);
        self.interactives = std.ArrayList(ButtonInteractive).init(allocator);
        self.behaviours = std.ArrayList(ButtonBehaviour).init(allocator);
    }

    pub fn deinit(self: *ButtonManager) void {
        self.visuals.deinit();
        self.interactives.deinit();
        self.behaviours.deinit();
    }
};

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

pub const ButtonBehaviour = struct {
    callback: ?ButtonCallBack,
};
