{ pkgs, lib, inputs, config, ... }: {
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;

  wayland.windowManager.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;
    settings = {
      monitor = map
          (m:
            let
              resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              position = "${toString m.x}x${toString m.y}";
            in
            "${m.name},${if m.enabled then "${resolution},${position},1" else "disable"}"
          )
          (config.monitors);
    };
  };
}
