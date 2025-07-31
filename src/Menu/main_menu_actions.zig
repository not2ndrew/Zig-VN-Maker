const rl = @import("raylib");
const main_menu = @import("main_menu");
const c = @import("constants");
const scene = @import("scene");
const story = @import("story");
const game_state = @import("game_state");

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const screen_width = c.SCREEN_WIDTH;
const screen_height = c.SCREEN_HEIGHT;
const left_panel_width = c.LEFT_PANEL_WIDTH;
const panel_screen_width = screen_width - left_panel_width;
const panel_x = left_panel_width + c.PADDING_X;

const ButtonCallBack = *const fn () void;

pub var current_state = MainMenuState.MainMenu;
pub var current_action: ?*const fn () void = null;

pub const MainMenuState = enum {
    Load,
    Setting,
    About,
    Help,
    Quit,
    None,
    MainMenu,
};

pub fn start() void {
    current_state = MainMenuState.None;
    game_state.pushState(game_state.GameState.Gameplay);
}

pub fn load() void {}

pub fn settings() void {}

pub fn about() void {
    const description: [:0]const u8 = "Zig VN Maker is made using Zig and Not Nik Raylib";
    rl.drawText(description, panel_x, 150, text_font_size, rl.Color.white);
}

pub fn help() void {
    // draw help
}

pub fn quit() void { main_menu.should_quit = true; }

pub fn drawCurrentPanel() void {
    drawPanel(current_state);
    if (current_action) |action| action();
}


pub fn setCallBack(state: MainMenuState, action: ?ButtonCallBack) ButtonCallBack {
    return struct {
        fn callback() void {
            current_state = state;
            current_action = action;
        }
    }.callback;
}

fn drawPanel(state: MainMenuState) void {
    const title = @tagName(state);

    current_state = state;

    rl.drawRectangle(left_panel_width, 0, panel_screen_width, screen_height, rl.colorAlpha(rl.Color.black, 0.5));
    rl.drawText(title, panel_x, 50, title_font_size, rl.Color.sky_blue);
}
