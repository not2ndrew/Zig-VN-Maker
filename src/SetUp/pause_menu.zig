const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const btn_system = @import("button_system");
const btn_components = @import("button_components");
const menu_options = @import("menu_options");
const game_state = @import("game_state");

const side_panel_width = @divTrunc(c.SCREEN_WIDTH, 4);
const screen_height = c.SCREEN_HEIGHT;
const screen_width = c.SCREEN_WIDTH;

const panel_screen_width = screen_width - side_panel_width;
const panel_x = side_panel_width + c.PADDING_X;

const text_x_padding = c.TEXT_X_PADDING;
const text_y_padding = c.TEXT_Y_PADDING;

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const text_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const text_y_pos = [_]i32{300, 360, 420, 480, 540, 600};
const title_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const title_y_pos = 200;

const title: [:0]const u8 = "Pause Menu";

const ButtonManager = btn_components.ButtonManager;
const ButtonVisual = btn_components.ButtonVisual;
const ButtonBehaviour = btn_components.ButtonBehaviour;

pub var current_substate = PauseMenuState.None;
pub var current_action: ?*const fn() void = null;

pub var pause_menu = ButtonManager{};

pub const PauseMenuState = enum {
    Save,
    Load,
    History,
    Setting,
    None,
};

const labels = [_][:0]const u8{
    "Save",
    "Load",
    "History",
    "Setting",
    "Resume",
    "Main Menu",
};

const visuals = blk: {
    var arr: [labels.len]ButtonVisual = undefined;

    for (0..labels.len) |i| {
        arr[i] = ButtonVisual{
            .label = labels[i],
            .x_position = text_x_pos,
            .y_position = text_y_pos[i],
            .x_padding = text_x_padding,
            .y_padding = text_y_padding,
            .font_size = text_font_size,
        };
    }

    break :blk arr;
};

const behaviours = [labels.len]ButtonBehaviour{
    setCallBack(PauseMenuState.Save, menu_options.saveGame),
    setCallBack(PauseMenuState.Load, menu_options.loadGame),
    setCallBack(PauseMenuState.History, menu_options.history),
    setCallBack(PauseMenuState.Setting, menu_options.setting),
    menu_options.resumeGame,
    menu_options.menu, // TODO: I'm not quite sure what I should do with this.
};

pub fn init(allocator: std.mem.Allocator) void {
    pause_menu.init(allocator);
    btn_system.setUpButtons(&pause_menu, &visuals, &behaviours, rl.Color.black) catch unreachable;
}

pub fn deinit() void {
    pause_menu.deinit();
}

pub fn setCallBack(state: PauseMenuState, action: ButtonBehaviour) ButtonBehaviour {
    return struct {
        fn callback() void {
            if (game_state.state_stack.getLast() != game_state.GameState.PauseMenu) {
                game_state.state_stack.append(game_state.GameState.PauseMenu) catch unreachable;
            }

            current_substate = state;
            current_action = action;
        }
    }.callback;
}

pub fn updatePauseMenu() void {
    btn_system.updateFrame(&pause_menu);
}

pub fn drawPauseMenu() void {
    const title_panel_x_pos = title_x_pos - @divTrunc(rl.measureText(title, title_font_size), 2);

    // Draw side panel
    rl.drawRectangle(0, 0, side_panel_width, screen_height, rl.Color.sky_blue);
    rl.drawText(title, title_panel_x_pos, title_y_pos, title_font_size, rl.Color.black);

    if (current_substate != PauseMenuState.None) drawCurrentPanel();

}

pub fn drawCurrentPanel() void {
    drawPanel(current_substate);
    if (current_action) |action| action();
}

fn drawPanel(state: PauseMenuState) void {
    const panel_title = @tagName(state);

    rl.drawRectangle(side_panel_width, 0, panel_screen_width, screen_height, rl.colorAlpha(rl.Color.black, 0.5));
    rl.drawText(panel_title, panel_x, 50, title_font_size, rl.Color.sky_blue);
}
