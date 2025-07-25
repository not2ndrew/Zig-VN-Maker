const std = @import("std");

pub var state_stack: std.ArrayList(GameState) = undefined;

pub const GameState = enum {
    None,
    MainMenu,
    Gameplay,
    PauseMenu,
};

pub fn init(allocator: std.mem.Allocator) void {
    state_stack = std.ArrayList(GameState).init(allocator);
    state_stack.append(GameState.MainMenu) catch unreachable;
}

pub fn deinit() void {
    state_stack.deinit();
}

pub fn pushState(state: GameState) void {
    state_stack.append(state) catch unreachable;
}

pub fn popState() void {
    if (state_stack.items.len > 1) {
        _ = state_stack.pop().?;
    }
}
