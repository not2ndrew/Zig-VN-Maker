const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ---------- MODULES ----------
    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const constants = b.createModule(.{
        .root_source_file = b.path("src/SetUp/constants.zig"),
    });

    const menus = b.createModule(.{
        .root_source_file = b.path("src/Menu/menus.zig"),
    });

    const buttons = b.createModule(.{
        .root_source_file = b.path("src/Button/buttons.zig"),
    });

    const scene = b.createModule(.{
        .root_source_file = b.path("src/Scene/scene.zig"),
    });

    const game_state = b.createModule(.{
        .root_source_file = b.path("src/State/game_state.zig"),
    });

    // ---------- DEPENDENCIES ----------
    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib"); // main raylib module
    const raygui = raylib_dep.module("raygui"); // raygui module
    const raylib_artifact = raylib_dep.artifact("raylib"); // raylib C library

    const exe = b.addExecutable(.{
        .name = "Zig_VN_Maker",
        .root_module = exe_mod,
    });

    menus.addImport("raylib", raylib);
    menus.addImport("constants", constants);
    menus.addImport("buttons", buttons);
    menus.addImport("game_state", game_state);

    buttons.addImport("raylib", raylib);

    scene.addImport("raylib", raylib);
    scene.addImport("constants", constants);
    scene.addImport("menus", menus);
    scene.addImport("buttons", buttons);
    scene.addImport("constants", constants);
    scene.addImport("game_state", game_state);

    game_state.addImport("menus", menus);
    game_state.addImport("scene", scene);

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);
    exe.root_module.addImport("constants", constants);
    exe.root_module.addImport("buttons", buttons);
    exe.root_module.addImport("menus", menus);
    exe.root_module.addImport("scene", scene);
    exe.root_module.addImport("game_state", game_state);
    
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
