const std = @import("std");
const rl = @import("raylib");
const btn_components = @import("button_components");

const ButtonManager = btn_components.ButtonManager;
const ButtonCallBack = btn_components.ButtonCallBack;
const ButtonVisual = btn_components.ButtonVisual;
const ButtonInteractive = btn_components.ButtonInteractive;
const ButtonBehaviour = btn_components.ButtonBehaviour;

pub fn updateFrame(visuals: []const ButtonVisual, interactives: []ButtonInteractive, behaviours: []const ButtonBehaviour, text_colours: []const rl.Color) void {
    renderButton(visuals, text_colours);
    updateButtonInteraction(visuals, interactives);
    updateButtonBehaviour(interactives, behaviours);
}

pub fn renderButton(visuals: []const ButtonVisual, text_colours: []const rl.Color) void {
    for (visuals, text_colours) |visual, text_colour| {
        drawButton(visual, text_colour);
    }
}

pub fn updateButtonInteraction(visuals: []const ButtonVisual, interactives: []ButtonInteractive) void {
    const mousePos = rl.getMousePosition();
    const num_of_btns = visuals.len;

    var any_hovered = false;

    for (0..num_of_btns) |i| {
        const visual = visuals[i];
        const rect = calcRect(visual);

        const is_hovered = rl.checkCollisionPointRec(mousePos, rect);
        const clicked = is_hovered and rl.isMouseButtonReleased(rl.MouseButton.left);

        interactives[i].hovered = is_hovered;
        interactives[i].clicked = clicked;

        if (is_hovered) any_hovered = true;
    }

    if (any_hovered) {
        rl.setMouseCursor(rl.MouseCursor.pointing_hand);
    } else {
        rl.setMouseCursor(rl.MouseCursor.default);
    }
}

pub fn updateButtonBehaviour(interactives: []ButtonInteractive, behaviours: []const ButtonBehaviour) void {
    for (interactives, behaviours) |interactive, behaviour| {
        if (interactive.clicked) {
            behaviour();
        }
    }
}

pub fn drawButton(visual: ButtonVisual, text_colour: rl.Color) void {
    const rect = calcRect(visual);
    rl.drawRectangle(
        @intFromFloat(rect.x),
        @intFromFloat(rect.y),
        @intFromFloat(rect.width),
        @intFromFloat(rect.height),
        rl.Color.blank,
    );

    const rect_x: i32 = @intFromFloat(rect.x);
    const rect_y: i32 = @intFromFloat(rect.y);
    const rect_width: i32 = @intFromFloat(rect.width);
    const rect_height: i32 = @intFromFloat(rect.height);

    const text_width = rl.measureText(visual.label, visual.font_size);
    const text_height = visual.font_size;
    const text_x_pos = rect_x + @divFloor(rect_width - text_width, 2);
    const text_y_pos = rect_y + @divFloor(rect_height - text_height, 2);

    rl.drawText(visual.label, text_x_pos, text_y_pos, visual.font_size, text_colour);
}

fn calcRect(visual: ButtonVisual) rl.Rectangle {
    const text_width = rl.measureText(visual.label, visual.font_size);
    const rect_width = text_width + 2 * visual.x_padding;
    const rect_height = visual.font_size + 2 * visual.y_padding;

    return rl.Rectangle{
        .x = @floatFromInt(visual.x_position - visual.x_padding),
        .y = @floatFromInt(visual.y_position - visual.y_padding),
        .width = @floatFromInt(rect_width),
        .height = @floatFromInt(rect_height),
    };
}
