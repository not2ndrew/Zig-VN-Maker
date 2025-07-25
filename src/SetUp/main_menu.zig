const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const btn_system = @import("button_system");
const btn_components = @import("button_components");
const menu_actions = @import("main_menu_actions");
const game_state = @import("game_state");

const side_panel_width = @divTrunc(c.SCREEN_WIDTH, 4);
const side_panel_height = c.SCREEN_HEIGHT;

const text_x_padding = c.TEXT_X_PADDING;
const text_y_padding = c.TEXT_Y_PADDING;

const title_font_size = c.TITLE_FONT_SIZE;
const text_font_size = c.TEXT_FONT_SIZE;

const text_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const text_y_pos = [_]i32{300, 360, 420, 480, 540, 600};
const title_x_pos = @divTrunc(side_panel_width, 2) - 2 * text_x_padding;
const title_y_pos = 200;

const title: [:0]const u8 = "Title";

const ButtonCallBack = *const fn() void;
const ButtonManager = btn_components.ButtonManager;
const MainMenuState = menu_actions.MainMenuState;
const setCallBack = menu_actions.setCallBack;

pub var main_menu = ButtonManager{};
pub var should_quit = false;

const main_menu_labels = [_][:0]const u8{
    "Start",
    "Load",
    "Setting",
    "About",
    "Help",
    "Quit",
};

// Start and quit do not need a MainMenuState. Start should transition to the Gameplay
// and Quit should exit the program.
const main_menu_behaviours = [_]?ButtonCallBack{
    menu_actions.start,
    setCallBack(MainMenuState.Load, menu_actions.load),
    setCallBack(MainMenuState.Setting, menu_actions.settings),
    setCallBack(MainMenuState.About, menu_actions.about),
    setCallBack(MainMenuState.Help, menu_actions.help),
    menu_actions.quit,
};

pub fn init(allocator: std.mem.Allocator) void {
    main_menu.init(allocator);
    game_state.init(allocator);
    setUpButtons();
}

pub fn deinit() void {
    main_menu.deinit();
    game_state.deinit();
}

pub fn drawMainMenu() void {
    drawSidePanel();

    if (menu_actions.current_state != MainMenuState.MainMenu) menu_actions.drawCurrentPanel();
}

pub fn updateMainMenu(menu: *ButtonManager) void {
    btn_system.updateFrame(menu);
}

pub fn drawSidePanel() void {
    rl.drawRectangle(0, 0, side_panel_width, side_panel_height, rl.Color.sky_blue);
    rl.drawText(title, title_x_pos, title_y_pos, title_font_size, rl.Color.black);
}

fn setUpButtons() void {
    for (0..main_menu_labels.len) |i| {
        btn_system.createButton(
            &main_menu,
            main_menu_labels[i],
            text_x_pos,
            text_y_pos[i],
            text_x_padding,
            text_y_padding,
            text_font_size,
            main_menu_behaviours[i]
        ) catch unreachable;
    }
}
