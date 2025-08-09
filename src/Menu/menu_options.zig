const rl = @import("raylib");
const c = @import("constants");
const main_menu = @import("main_menu.zig");
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

pub fn quitGame() void { game_state.should_quit = true; }

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
// Due to how large settings is going to be, we should move it to a different fire entirely.
const slider_y_pos = 300;
const slider_height = 50;

const slider = rl.Rectangle{
    .x = left_panel_width,
    .y = slider_y_pos,
    .width = 500,
    .height = slider_height,
};

const knob_x = left_panel_width + @divTrunc(slider.width, 2);

var knob = rl.Rectangle{
    .x = knob_x,
    .y = slider_y_pos,
    .width = 100,
    .height = slider_height,
};

pub fn setting() void {
    // set_cfg.drawSliderWithKnob(volume_slider, &set_comp.volume_knob, tempFn);
}

pub fn loadGame() void {}

pub fn tempFn() void {}

pub var dragging = false;

const SliderError = error {
    KnobWidthTooLarge,
    KnobNotAttached
};


// TODO: Incase for potential error, return !void instead.
// Error possibilities:
// 1) Knob's width is larger than slider's width
// 2) knob's x and y position is disconnected from slider's x and y position.
//
// Test: What happens if there are multiple sliderWithKnob()? Do they all share the dragging variable?
// pub fn drawSliderWithKnob(slider: rl.Rectangle, knob: *rl.Rectangle, behaviour: *const fn () void) void {
//     const mousePos = rl.getMousePosition();
//     const hoveredOverKnob = rl.checkCollisionPointRec(mousePos, knob.*);
//     const leftMouseDown = rl.isMouseButtonDown(rl.MouseButton.left);
//     const leftMouseReleased = rl.isMouseButtonReleased(rl.MouseButton.left);
//
//     if (hoveredOverKnob and leftMouseDown) {
//         dragging = true;
//     } else if (leftMouseReleased) {
//         dragging = false;
//     }
//
//     if (dragging) {
//         const half_knob_width = @divTrunc(knob.width, 2);
//         var new_x_position = mousePos.x - half_knob_width;
//
//         const min_x_position = slider.x;
//         const max_x_position = slider.x + slider.width - knob.width;
//
//         if (new_x_position <= min_x_position) new_x_position = min_x_position;
//         if (new_x_position >= max_x_position) new_x_position = max_x_position;
//
//         knob.x = new_x_position;
//         behaviour();
//     }
//
//     rl.drawRectangleRec(slider, rl.Color.white);
//     rl.drawRectangleRec(knob.*, rl.Color.black);
// }
//
// pub fn drawToggleSwitch(toggle_switch: rl.Rectangle, toggle: *const fn () void) void {
//     const mousePos = rl.getMousePosition();
//     const hoveredOverToggle = rl.checkCollisionPointRec(mousePos, toggle_switch);
//     const leftMouseDown = rl.isMouseButtonDown(rl.MouseButton.left);
//
//     rl.drawRectangleRec(toggle_switch, rl.Color.white);
//
//     if (hoveredOverToggle and leftMouseDown) {
//         toggle();
//     }
// }
