const rl = @import("raylib");
const c = @import("constants");
const game_state = @import("game_state");

const side_panel_width = @divTrunc(c.SCREEN_WIDTH, 4);
const screen_height = c.SCREEN_HEIGHT;

const text_x_padding = c.TEXT_X_PADDING;
const text_y_padding = c.TEXT_Y_PADDING;

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const title_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const title_y_pos = 200;

const title: [:0]const u8 = "Title";

pub const PauseMenuState = enum {
    Save,
    Load,
    History,
    Setting,
    Resume,
    Quit,
    None,
};

const ButtonCallBack = *const fn () void;

pub var current_state = PauseMenuState.None;
pub var current_action: ?ButtonCallBack = null;

pub fn setCallBack(state: PauseMenuState, action: ?ButtonCallBack) ButtonCallBack {
    return struct {
        fn callback() void {
            current_state = state;
            current_action = action;
        }
    }.callback;
}

pub fn save() void {}
pub fn load() void {}
pub fn history() void {}
pub fn setting() void {}
pub fn resumeGameplay() void {
    game_state.popState();
}
pub fn quit() void {}
