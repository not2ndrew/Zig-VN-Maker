const std = @import("std");
const main_menu = @import("main_menu");
const command_menu = @import("command_menu");
const pause_menu = @import("pause_menu");
const scene = @import("scene");

const SceneManager = scene.SceneManager;

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

pub fn gameStateManager(scene_manager: *SceneManager) void {
    switch (state_stack.getLast()) {
            GameState.MainMenu => {
                main_menu.drawMainMenu();
                main_menu.updateMainMenu();
            },
            GameState.Gameplay => {
                scene_manager.renderScene();
                scene_manager.updateScene();
                command_menu.updateCommandMenu();
            },
            GameState.PauseMenu => {
                pause_menu.drawPauseMenu();
                pause_menu.updatePauseMenu();
            },
            GameState.None => {},
        }
}

// pub fn gameStateMan() void {
//     main_menu.drawMainMenu();
//     main_menu.updateMainMenu();
// }
