const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const btn_system = @import("button_system");
const btn_components = @import("button_components");
const game_state = @import("game_state");
const pause_behaviour = @import("pause_behaviour");

const side_panel_width = @divTrunc(c.SCREEN_WIDTH, 4);
const screen_height = c.SCREEN_HEIGHT;

const text_x_padding = c.TEXT_X_PADDING;
const text_y_padding = c.TEXT_Y_PADDING;

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const text_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const text_y_pos = [_]i32{300, 360, 420, 480, 540, 600};

const PauseMenuState = pause_behaviour.PauseMenuState;
const setCallBack = pause_behaviour.setCallBack;

const ButtonManager = btn_components.ButtonManager;
const ButtonVisual = btn_components.ButtonVisual;
const ButtonBehaviour = btn_components.ButtonBehaviour;

const labels = [_][:0]const u8{
    "Save",
    "Load",
    "History",
    "Setting",
    "Resume",
    "Menu",
};

const visuals = blk: {
    var temp: [labels.len]ButtonVisual = undefined;

    for (0..labels.len) |i| {
        temp[i] = ButtonVisual{
            .label = labels[i],
            .x_position = text_x_pos,
            .y_position = text_y_pos[i],
            .x_padding = text_x_padding,
            .y_padding = text_y_padding,
            .font_size = text_font_size,
        };
    }

    break :blk temp;
};

const behaviours = [labels.len]ButtonBehaviour{
    pause_behaviour.save,
    setCallBack(PauseMenuState.Load, pause_behaviour.load),
    setCallBack(PauseMenuState.History, pause_behaviour.history),
    setCallBack(PauseMenuState.Setting, pause_behaviour.settings),
    pause_behaviour.resumeGameplay,
    pause_behaviour.quit,
};

pub var pause_menu = ButtonManager{};

pub fn init(allocator: std.mem.Allocator) void {
    btn_system.setUpButtons(&pause_menu, visuals, behaviours, rl.Color.black);
    pause_menu.init(allocator);
}

pub fn deinit() void {
    pause_menu.deinit();
}
