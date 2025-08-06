const rl = @import("raylib");
const c = @import("constants");
const main_menu = @import("main_menu");
const game_state = @import("game_state");

const text_font_size = c.TEXT_FONT_SIZE;

const left_panel_width = c.LEFT_PANEL_WIDTH;
const panel_x = left_panel_width + c.PADDING_X;

const GameState = game_state.GameState;


// Main Menu Options only
pub fn startGame() void {
    main_menu.current_state = main_menu.MainMenuState.None;
    game_state.pushState(GameState.Gameplay);
}

pub fn quitGame() void { main_menu.should_quit = true; }

pub fn about() void {
    const description: [:0]const u8 = "Zig VN Maker is made using Zig and Not Nik Raylib";
    rl.drawText(description, panel_x, 150, text_font_size, rl.Color.white);
}

pub fn help() void {}


// Gameplay only
pub fn auto() void {}
pub fn skip() void {}
pub fn previousScene() void {}


// Gameplay and Pause Menu Options only
pub fn saveGame() void {}
pub fn menu() void {
    while (game_state.state_stack.getLast() != GameState.MainMenu) {
        game_state.popState();
    }

    main_menu.current_state = main_menu.MainMenuState.MainMenu;
}
pub fn resumeGame() void { game_state.popState(); }
pub fn history() void {}


// Main Menu, Gameplay, and Pause Menu
pub fn setting() void {}
pub fn loadGame() void {}
