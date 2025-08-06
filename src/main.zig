const rl = @import("raylib");
const std = @import("std");
const c = @import("constants");
const scene = @import("scene");
const main_menu = @import("main_menu");
const story = @import("story");
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

    game_state.initMenus(allocator);
    defer game_state.deinitMenus();

    rl.setTargetFPS(60);
    while (!rl.windowShouldClose() and !main_menu.should_quit) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        game_state.gameStateManager(&scene_manager);
    }
}
