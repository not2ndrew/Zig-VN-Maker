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
const ButtonInteractive = btn_components.ButtonInteractive;
const ButtonBehaviour = btn_components.ButtonBehaviour;
const PauseMenuState = pause_menu.PauseMenuState;

const setCallBack = pause_menu.setCallBack;

const labels = [_][:0]const u8{
    "Save",
    "Load",
    "Rewind",
    "Auto",
    "Skip",
    "History",
    "Pause Menu",
};

// TODO: Find a way to create evenly-spaced x positions with words of different length.
// Cannot use raylib function measureText() because it is an extern function
// that is run-time instead of comp-time.
const x_positions = blk: {
    var arr: [labels.len]i32 = undefined;
    var x_position: i32 = 500;

    for (0..labels.len) |i| {
        arr[i] = x_position;
        x_position += @as(i32, @intCast(labels[i].len * text_font_size));
    }

    break :blk arr;
};

const visuals = blk: {
    const command_menu_y_pos: i32 = 950;
    var temp: [labels.len]ButtonVisual = undefined;

    for (0..labels.len) |i| {
        temp[i] = ButtonVisual{
            .label = labels[i],
            .x_position = x_positions[i],
            .y_position = command_menu_y_pos,
            .x_padding = text_x_padding,
            .y_padding = text_y_padding,
            .font_size = text_font_size,
        };
    }

    break :blk temp;
};

var interactives = blk: {
    var temp: [labels.len]ButtonInteractive = undefined;

    for (0..labels.len) |i| {
        temp[i] = ButtonInteractive{ .hovered = false, .clicked = false };
    }

    break :blk temp;
};

const behaviours = [labels.len]ButtonBehaviour{
    setCallBack(PauseMenuState.Save, menu_options.saveGame),
    setCallBack(PauseMenuState.Load, menu_options.loadGame),
    menu_options.previousScene,
    menu_options.auto,
    menu_options.skip,
    setCallBack(PauseMenuState.History, menu_options.history),
    setCallBack(PauseMenuState.None, menu_options.menu),
};

const text_colours = blk: {
    var temp: [labels.len]rl.Color = undefined;

    for (0..labels.len) |i| {
        temp[i] = rl.Color.white;
    }

    break :blk temp;
};

pub fn updateCommandMenu() void {
    btn_system.updateFrame(&visuals, &interactives, &behaviours, &text_colours);
}
