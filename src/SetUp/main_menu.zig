const std = @import("std");
const rl = @import("raylib");
const c = @import("constants");
const btn_system = @import("button_system");
const btn_components = @import("button_components");
const menu_options = @import("menu_options");
const game_state = @import("game_state");

const screen_height = c.SCREEN_HEIGHT;
const screen_width = c.SCREEN_WIDTH;

const side_panel_width = c.LEFT_PANEL_WIDTH;
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

const title: [:0]const u8 = "Title";

const ButtonManager = btn_components.ButtonManager;
const ButtonVisual = btn_components.ButtonVisual;
const ButtonBehaviour = btn_components.ButtonBehaviour;

pub var main_menu = ButtonManager{};
pub var should_quit = false;

pub var current_state = MainMenuState.MainMenu;
pub var current_action: ?*const fn () void = null;

pub const MainMenuState = enum {
    Start,
    Quit,
    About,
    Setting,
    Load,
    Help,
    MainMenu,
    None,
};

const labels = [_][:0]const u8{
    "Start",
    "Load",
    "Setting",
    "About",
    "Help",
    "Quit",
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

// Start and quit do not need a MenuState. Start should transition to the Gameplay
// and Quit should exit the program.
const behaviours = [labels.len]ButtonBehaviour{
    menu_options.startGame,
    setCallBack(MainMenuState.Load, menu_options.loadGame),
    setCallBack(MainMenuState.Setting, menu_options.setting),
    setCallBack(MainMenuState.About, menu_options.about),
    setCallBack(MainMenuState.Help, menu_options.help),
    menu_options.quitGame,
};

pub fn setCallBack(state: MainMenuState, action: ButtonBehaviour) ButtonBehaviour {
    return struct {
        fn callback() void {
            current_state = state;
            current_action = action;
        }
    }.callback;
}

pub fn init(allocator: std.mem.Allocator) void {
    main_menu.init(allocator);
    game_state.init(allocator);
    btn_system.setUpButtons(&main_menu, &visuals, &behaviours, rl.Color.black) catch unreachable;
}

pub fn deinit() void {
    main_menu.deinit();
    game_state.deinit();
}

pub fn drawMainMenu() void {
    // Draw Side Panel
    rl.drawRectangle(0, 0, side_panel_width, screen_height, rl.Color.sky_blue);
    rl.drawText(title, title_x_pos, title_y_pos, title_font_size, rl.Color.black);

    if (current_state != MainMenuState.MainMenu) drawCurrentPanel();
}

pub fn updateMainMenu(menu: *ButtonManager) void {
    btn_system.updateFrame(menu);
}

pub fn drawCurrentPanel() void {
    drawPanel(current_state);
    if (current_action) |action| action();
}

fn drawPanel(state: MainMenuState) void {
    const panel_title = @tagName(state);

    current_state = state;

    rl.drawRectangle(side_panel_width, 0, panel_screen_width, screen_height, rl.colorAlpha(rl.Color.black, 0.5));
    rl.drawText(panel_title, panel_x, 50, title_font_size, rl.Color.sky_blue);
}
