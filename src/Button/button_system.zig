const std = @import("std");
const rl = @import("raylib");
const btn_components = @import("button_components");

const ButtonManager = btn_components.ButtonManager;
const ButtonCallBack = btn_components.ButtonCallBack;
const ButtonVisual = btn_components.ButtonVisual;
const ButtonInteractive = btn_components.ButtonInteractive;
const ButtonBehaviour = btn_components.ButtonBehaviour;

const ArrayList = std.ArrayList;

pub fn updateFrame(self: *ButtonManager) void {
    renderButton(&self.visuals);
    updateButtonInteraction(&self.visuals, &self.interactives);
    updateButtonBehaviour(&self.interactives, &self.behaviours);
}

pub fn updateButtonInteraction(visuals: *ArrayList(ButtonVisual), interactives: *ArrayList(ButtonInteractive)) void {
    const mousePos = rl.getMousePosition();
    const num_of_btns = visuals.items.len;

    var any_hovered = false;

    for (0..num_of_btns) |i| {
        const visual = visuals.items[i];
        const rect = calcRect(visual);

        const is_hovered = rl.checkCollisionPointRec(mousePos, rect);
        const clicked = is_hovered and rl.isMouseButtonReleased(rl.MouseButton.left);

        interactives.items[i].hovered = is_hovered;
        interactives.items[i].clicked = clicked;

        if (is_hovered) any_hovered = true;
    }

    if (any_hovered) {
        rl.setMouseCursor(rl.MouseCursor.pointing_hand);
    } else {
        rl.setMouseCursor(rl.MouseCursor.default);
    }
}

pub fn updateButtonBehaviour(interactives: *ArrayList(ButtonInteractive), behaviours: *ArrayList(ButtonBehaviour)) void {
    const num_of_btns = interactives.items.len;
    for (0..num_of_btns) |i| {
        if (interactives.items[i].clicked) {
            if (behaviours.items[i].callback) |cb| {
                cb();
            }
        }
    }
}

pub fn renderButton(visuals: *ArrayList(ButtonVisual)) void {
    const num_of_btns = visuals.items.len;
    for (0..num_of_btns) |i| {
        drawButton(visuals.items[i]);
    }
}

pub fn drawButton(visual: ButtonVisual) void {
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

    rl.drawText(visual.label, text_x_pos, text_y_pos, visual.font_size, rl.Color.black);

}

pub fn createButton(self: *ButtonManager, label: [:0]const u8, posX: i32, posY: i32, paddingX: i32, paddingY: i32, font_size: i32, callback: ?ButtonCallBack) !void {
    const visual = ButtonVisual{
        .label = label,
        .x_position = posX,
        .y_position = posY,
        .x_padding = paddingX,
        .y_padding = paddingY,
        .font_size = font_size,
    };

    const interactive = ButtonInteractive{
        .hovered = false,
        .clicked = false,
    };

    const behaviour = ButtonBehaviour{ .callback = callback };

    try self.visuals.append(visual);
    try self.interactives.append(interactive);
    try self.behaviours.append(behaviour);
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
