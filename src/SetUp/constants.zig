// Screen Dimensions
pub const SCREEN_WIDTH = 2000;
pub const SCREEN_HEIGHT = 1000;

// Fonts and Texts
pub const TITLE_FONT_SIZE = 40;
pub const TEXT_FONT_SIZE = 24;
pub const TEXT_X_POS = @divFloor(SCREEN_WIDTH, 4) - @divFloor(SCREEN_WIDTH, 8);
pub const TEXT_Y_POS = 100;

// Side Panel
pub const LEFT_PANEL_WIDTH = @divFloor(SCREEN_WIDTH, 4);

// Dialogue
pub const DIALOGUE_HEIGHT = SCREEN_HEIGHT - @divFloor(SCREEN_HEIGHT, 20);

// Padding
pub const PADDING_X = 100;
pub const PADDING_Y = 70;

// default X padding: TEXT_FONT_SIZE * 0.25
pub const TEXT_X_PADDING: i32 = @intFromFloat(TEXT_FONT_SIZE * 0.5);
// default Y padding: TEXT_FONT_SIZE * 0.25
pub const TEXT_Y_PADDING: i32 = @intFromFloat(TEXT_FONT_SIZE * 0.35);

