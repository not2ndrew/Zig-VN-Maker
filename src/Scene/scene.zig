const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const main_menu = @import("main_menu");
const menu_action = @import("main_menu_actions");
const game_state = @import("game_state");

const screen_width = c.SCREEN_WIDTH;
const screen_height = c.SCREEN_HEIGHT;
const padding_x = c.PADDING_X;
const padding_y = c.PADDING_Y;
const name_y_padding = 30;
const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;
const text_y_pos = c.TEXT_Y_POS;
const offset_x = 300;
const menu_height = 100;

const text_x_pos = offset_x + padding_x;

pub const Scene = struct {
    character_name: [:0]const u8,
    lines: []const [:0]const u8,
    current_line: usize = 0,
    // In the future, implement an ECS design
    // for sound effects, screen shake, transitions, etc.
    // Not all scenes have these features. So assigning them an ID would be efficient.
};

pub const SceneManager = struct {
    scene_list: []Scene = undefined,
    current_scene: usize = 0,

    pub fn nextSceneLine(self: *SceneManager) void {
        if (self.scene_list.len == 0) return;

        const scene = &self.scene_list[self.current_scene];
        scene.current_line += 1;
        if (scene.current_line >= scene.lines.len) self.nextScene();
    }

    pub fn nextScene(self: *SceneManager) void {
        self.current_scene += 1;
        if (self.current_scene >= self.scene_list.len) self.resetScenes();
    }

    pub fn resetScenes(self: *SceneManager) void {
        menu_action.current_state = menu_action.MainMenuState.MainMenu;
        self.current_scene = 0;
        self.resetAllSceneLines();
        game_state.popState();
    }

    fn resetAllSceneLines(self: *SceneManager) void {
        for (self.scene_list) |*scene| {
            scene.current_line = 0;
        }
    }

    pub fn jumpToScene(self: *SceneManager, scene_id: usize) void {
        self.current_scene = scene_id;
    }

    fn drawDialogue(scene: *const Scene) void {
        const dialogue_background = rl.Color.alpha(rl.Color.black, 0.5);
        const dialogue_height = @divFloor(screen_height, 4);

        rl.drawRectangle(0, screen_height - dialogue_height, screen_width, dialogue_height, dialogue_background);

        const name_y_pos: i32 = screen_height - dialogue_height + name_y_padding;
        rl.drawText(scene.character_name, text_x_pos, name_y_pos, title_font_size, rl.Color.white);

        const dialogue_y_pos: i32 = screen_height - dialogue_height + text_y_pos;
        rl.drawText(scene.lines[scene.current_line], text_x_pos, dialogue_y_pos, text_font_size, rl.Color.white);
    }

    pub fn updateScene(self: *SceneManager) void {
        const mousePos = rl.getMousePosition();

        const screenRect = rl.Rectangle{
            .x = 0.0,
            .y = 0.0,
            .width = @floatFromInt(screen_width),
            .height = @floatFromInt(screen_height - menu_height),
        };

        const isClickable = rl.checkCollisionPointRec(mousePos, screenRect);
        const isInteractPressed = rl.isMouseButtonPressed(rl.MouseButton.left) or rl.isKeyPressed(rl.KeyboardKey.space);
        if (isClickable and isInteractPressed) nextSceneLine(self);
    }

    pub fn renderScene(self: *const SceneManager) void {
        const scene = self.scene_list[self.current_scene];

        if (scene.current_line < scene.lines.len) {
            drawDialogue(&scene);
        }
    }
};
