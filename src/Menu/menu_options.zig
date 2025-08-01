const rl = @import("raylib");
const c = @import("constants");
const main_menu = @import("main_menu");
const main_actions = @import("main_menu_actions");
const game_state = @import("game_state");

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const screen_width = c.SCREEN_WIDTH;
const screen_height = c.SCREEN_HEIGHT;
const left_panel_width = c.LEFT_PANEL_WIDTH;
const panel_screen_width = screen_width - left_panel_width;
const panel_x = left_panel_width + c.PADDING_X;

const GameState = game_state.GameState;

pub const MenuState = enum {
    Start,
    Quit,
    About,
    Save,
    MainMenu,
    ResumeGame,
    Setting,
    Load,
    Help,
    None,
};


// Main Menu Options only
pub fn startGame() void {
    main_actions.current_state = MenuState.None;
    game_state.pushState(GameState.Gameplay);
}

pub fn quitGame() void { main_menu.should_quit = true; }

pub fn about() void {
    const description: [:0]const u8 = "Zig VN Maker is made using Zig and Not Nik Raylib";
    rl.drawText(description, panel_x, 150, text_font_size, rl.Color.white);
}

pub fn help() void {}


// Gameplay and Pause Menu Options only
pub fn save() void {}
pub fn menu() void {}
pub fn resumeGame() void { game_state.popState(); }


// Main Menu, Gameplay, and Pause Menu
pub fn setting() void {}
pub fn loadGame() void {}
