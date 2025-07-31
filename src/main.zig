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

    main_menu.init(allocator);
    defer main_menu.deinit();

    rl.setTargetFPS(60);
    while (!rl.windowShouldClose() and !main_menu.should_quit) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        // TODO: move this to the game_state file and create a function called game_state_manager.
        switch (game_state.state_stack.getLast()) {
            GameState.MainMenu => {
                main_menu.drawMainMenu();
                main_menu.updateMainMenu(&main_menu.main_menu);
            },
            GameState.Gameplay => {
                scene_manager.renderScene();
                scene_manager.updateScene();
            },
            GameState.PauseMenu => {},
            GameState.None => {},
        }
    }
}
