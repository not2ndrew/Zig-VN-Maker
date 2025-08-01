const rl = @import("raylib");
const menu_options = @import("menu_options");
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
const MenuState = menu_options.MenuState;

pub var current_state = MenuState.MainMenu;
pub var current_action: ?*const fn () void = null;

pub fn setCallBack(state: MenuState, action: ?ButtonCallBack) ButtonCallBack {
    return struct {
        fn callback() void {
            current_state = state;
            current_action = action;
        }
    }.callback;
}
