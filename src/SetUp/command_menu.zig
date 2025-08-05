const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const btn_system = @import("button_system");
const btn_components = @import("button_components");
const menu_options = @import("menu_options");
const game_state = @import("game_state");
const pause_menu = @import("pause_menu");

const screen_height = c.SCREEN_HEIGHT;
const screen_width = c.SCREEN_WIDTH;

const side_panel_width = c.LEFT_PANEL_WIDTH;
const panel_screen_width = screen_width - side_panel_width;
const panel_x = side_panel_width + c.PADDING_X;

const text_x_padding = c.TEXT_X_PADDING;
const text_y_padding = c.TEXT_Y_PADDING;

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const title_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const title_y_pos = 200;

const ButtonManager = btn_components.ButtonManager;
const ButtonVisual = btn_components.ButtonVisual;
const ButtonBehaviour = btn_components.ButtonBehaviour;
const PauseMenuState = pause_menu.PauseMenuState;

const setCallBack = pause_menu.setCallBack;

pub var command_menu = ButtonManager{};

const labels = [_][:0]const u8{
    "Save",
    "Load",
    "Rewind",
    "Auto",
    "Skip",
    "History",
    "Pause Menu",
};

// x_positions is calculated at run-time due to extern function measureText().
fn calculateXPositions() [labels.len]i32 {
    const text_x_spacing = 50;
    var arr: [labels.len]i32 = undefined;
    var x_position: i32 = 600;

    for (0..labels.len) |i| {
        arr[i] = x_position;
        x_position += rl.measureText(labels[i], text_font_size) + text_x_spacing;
    }

    return arr;
}

fn generateVisuals() [labels.len]ButtonVisual {
    const command_menu_y_pos = screen_height - text_font_size - text_y_padding;
    const x_arr: [labels.len]i32 = calculateXPositions();

    var arr: [labels.len]ButtonVisual = undefined;

    for (0..labels.len) |i| {
        arr[i] = ButtonVisual{
            .label = labels[i],
            .x_position = x_arr[i],
            .y_position = command_menu_y_pos,
            .x_padding = text_x_padding,
            .y_padding = text_y_padding,
            .font_size = text_font_size,
        };
    }

    return arr;
}

const behaviours = [labels.len]ButtonBehaviour{
    setCallBack(PauseMenuState.Save, menu_options.saveGame),
    setCallBack(PauseMenuState.Load, menu_options.loadGame),
    menu_options.previousScene,
    menu_options.auto,
    menu_options.skip,
    menu_options.history,
    setCallBack(PauseMenuState.None, menu_options.menu),
};

pub fn init(allocator: std.mem.Allocator) void {
    command_menu.init(allocator);

    const visuals = generateVisuals();
    btn_system.setUpButtons(&command_menu, &visuals, &behaviours, rl.Color.white) catch unreachable;
}

pub fn deinit() void {
    command_menu.deinit();
}

pub fn updateCommandMenu() void {
    btn_system.updateFrame(&command_menu);
}
