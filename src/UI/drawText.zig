const rl = @import("raylib");
const btn_system = @import("button_system");
const btn_components = @import("button_components");

const ButtonVisual = btn_components.ButtonVisual;
const ButtonInteractive = btn_components.ButtonInteractive;

pub const TextBlock = struct {
    lines: []const [:0]const u8,
    title: [:0]const u8,
    posX: i32,
    posY: i32,
    offsetY: i32,
    fontSizeTitle: i32,
    fontSizeText: i32,
    titleColor: rl.Color,
    textColor: rl.Color,
};

pub fn drawVerticalTextLines(lines: []const [:0]const u8, xPos: i32, yPos: i32, offset_y: i32, fontSize: i32, textColor: rl.Color) void {
    var new_yPos = yPos;

    for (lines) |line| {
        rl.drawText(line, xPos, new_yPos + offset_y, fontSize, textColor);
        new_yPos += offset_y;
    }
}

pub fn drawTextBlock(block: *const TextBlock) void {
    rl.drawText(block.title, block.posX, block.posY, block.fontSizeTitle, block.titleColor);
    drawVerticalTextLines(block.lines, block.posX, block.posY + block.offsetY, block.offsetY, block.fontSizeText, block.textColor);
}

// TODO: rename the file from drawText.zig -> inputComponent.zig
// Or, ignore the drawText.zig and create a new file inputComponent.zig

// pub fn drawSliderWithKnob(slider: rl.Rectangle, knob_visual: ButtonVisual, knob_interactive: ButtonInteractive) void {
//     rl.drawRectangleRec(slider, rl.Color.white);
// }
