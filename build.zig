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

    const button_components = b.createModule(.{
        .root_source_file = b.path("src/Button/button_components.zig"),
    });

    const button_system = b.createModule(.{
        .root_source_file = b.path("src/Button/button_system.zig"),
    });

    const menu_options = b.createModule(.{
        .root_source_file = b.path("src/Menu/menu_options.zig"),
    });

    const drawText = b.createModule(.{
        .root_source_file = b.path("src/UI/drawText.zig"),
    });

    const scene = b.createModule(.{
        .root_source_file = b.path("src/Scene/scene.zig"),
    });

    const main_menu = b.createModule(.{
        .root_source_file = b.path("src/SetUp/main_menu.zig"),
    });

    const main_menu_actions = b.createModule(.{
        .root_source_file = b.path("src/Menu/main_menu_actions.zig"),
    });

    const pause_menu = b.createModule(.{
        .root_source_file = b.path("src/SetUp/pause_menu.zig"),
    });

    const pause_behaviour = b.createModule(.{
        .root_source_file = b.path("src/Menu/pause_behaviour.zig"),
    });

    const story = b.createModule(.{
        .root_source_file = b.path("src/SetUp/story.zig"),
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

    // Add imports

    drawText.addImport("raylib", raylib);

    scene.addImport("raylib", raylib);
    scene.addImport("constants", constants);
    scene.addImport("main_menu", main_menu);
    scene.addImport("menu_options", menu_options);
    scene.addImport("game_state", game_state);
    scene.addImport("main_menu_actions", main_menu_actions);

    button_components.addImport("raylib", raylib);

    button_system.addImport("raylib", raylib);
    button_system.addImport("button_components", button_components);

    menu_options.addImport("raylib", raylib);
    menu_options.addImport("constants", constants);
    menu_options.addImport("main_menu", main_menu);
    menu_options.addImport("main_menu_actions", main_menu_actions);
    menu_options.addImport("game_state", game_state);

    main_menu.addImport("raylib", raylib);
    main_menu.addImport("constants", constants);
    main_menu.addImport("button_system", button_system);
    main_menu.addImport("button_components", button_components);
    main_menu.addImport("menu_options", menu_options);
    main_menu.addImport("main_menu_actions", main_menu_actions);
    main_menu.addImport("game_state", game_state);

    main_menu_actions.addImport("raylib", raylib);
    main_menu_actions.addImport("menu_options", menu_options);
    main_menu_actions.addImport("main_menu", main_menu);
    main_menu_actions.addImport("constants", constants);
    main_menu_actions.addImport("scene", scene);
    main_menu_actions.addImport("story", story);
    main_menu_actions.addImport("game_state", game_state);

    pause_menu.addImport("raylib", raylib);
    pause_menu.addImport("contants", constants);
    pause_menu.addImport("button_system", button_system);
    pause_menu.addImport("button_components", button_components);
    pause_menu.addImport("game_state", game_state);
    pause_menu.addImport("pause_behaviour", pause_behaviour);

    pause_behaviour.addImport("raylib", raylib);
    pause_behaviour.addImport("constants", constants);
    pause_behaviour.addImport("game_state", game_state);

    story.addImport("scene", scene);

    exe.linkLibrary(raylib_artifact);
    exe.root_module.addImport("raylib", raylib);
    exe.root_module.addImport("raygui", raygui);
    exe.root_module.addImport("constants", constants);
    exe.root_module.addImport("scene", scene);
    exe.root_module.addImport("main_menu", main_menu);
    exe.root_module.addImport("story", story);
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
