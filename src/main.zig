const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const scene = @import("scene");
const story = @import("SetUp/story.zig");
const game_state = @import("game_state");

const screen_width = c.SCREEN_WIDTH;
const screen_height = c.SCREEN_HEIGHT;

const GameState = game_state.GameState;

pub fn main() !void {
    var debugalloc = std.heap.DebugAllocator(.{}){};
    defer _ = debugalloc.deinit();

    const allocator = debugalloc.allocator();

    rl.initWindow(screen_width, screen_height, "window");
    defer rl.closeWindow();

    var scene_manager = scene.SceneManager{};
    scene_manager.scene_list = story.slicedScenes;

    game_state.init(allocator);
    defer game_state.deinit();

    rl.setTargetFPS(60);
    while (!rl.windowShouldClose() and !game_state.should_quit) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        game_state.gameStateManager(&scene_manager);
    }
}
