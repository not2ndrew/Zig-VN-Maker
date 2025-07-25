const scene = @import("scene");

const Scene = scene.Scene;

pub const introLines = [_][:0]const u8{
    "This is the beginning of your story",
    "Something strange is happening...",
    "BOOOOOOOOOOOOOM",
};

pub const chapter1Lines = [_][:0]const u8{
    "CHAPTER 1: The dummy test",
};

pub const intro = Scene{ .character_name = "Narrator", .lines = &introLines };
pub const chapter1 = Scene{ .character_name = "", .lines = &chapter1Lines };

var scenes = [_]Scene{intro, chapter1};
pub const slicedScenes: []Scene = scenes[0..];
