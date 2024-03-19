{ pkgs, lib, inputs, config, ... }: {

  wayland.windowManager.hyprland = {
    enable = true;
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

      exec-once = [
        "waybar"
        "python3 /home/caches/script.py"
      ];

      "$terminal" = "kitty";
      "$mainMod" = "SUPER";

      general = {
        resize_on_border = true;
        border_size = 2;
        gaps_out = 10;
      };

      decoration = {
        rounding = 5;
        active_opacity = 0.95;
        inactive_opacity = 0.95;
        fullscreen_opacity = 0.95;
        dim_inactive = false;
      };

      input = {
      sensitivity = 0.2;
      accel_profile = "flat";
      follow_mouse = 2;
      };

      windowrulev2 = [
        "noblur,class:(firefox)"
        "opacity 1 override,class:(firefox)"
      ];

      bind = [
        "$mainMod, T, exec, $terminal"
        "$mainMod, Q, killactive, "

        # Switch workspaces with numbers
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move focus with mainMod + arrow keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Switch workspaces with jk
        "$mainMod, j, workspace, e+1"
        "$mainMod, k, workspace, e-1"

        # Move windows to another workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
