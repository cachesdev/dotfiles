{ pkgs, lib, inputs, config, ... }: {

  wayland.windowManager.hyprland.systemd.enable = true;
  wayland.windowManager.hyprland.xwayland.enable = true;
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
        # "xwaylandvideobridge"
        "waybar"
        "python3 /home/caches/.dotfiles/scripts/swww.py"
        "dunst"
      ];

      "$terminal" = "kitty";
      "$mainMod" = "SUPER";

      general = {
        resize_on_border = true;
        border_size = 4;
        gaps_out = 10;
        "col.active_border" = "rgb(94e2d5) rgb(89dceb) rgb(74c7ec) rgb(89b4fa) rgb(b4befe) rgb(babbf1) 52deg";
      };

      misc = {
        disable_hyprland_logo = true;
      };

      decoration = {
        rounding = 5;
        active_opacity = 0.95;
        inactive_opacity = 0.95;
        fullscreen_opacity = 0.95;
        dim_inactive = false;
        blur = {
          size = 5;
          passes = 3;
          contrast = 1;
          brightness = 1.0;
          vibrancy = 0.5;
          vibrancy_darkness = 0.5;
          ignore_opacity = true;
        };
      };

      input = {
        sensitivity = 0.2;
        accel_profile = "flat";
        follow_mouse = 2;
        kb_layout = "us,latam";
        touchpad = {
          natural_scroll = true;
        };
      };

      device = [
        { 
          name = "corsair-corsair-gaming-k70-lux-rgb-keyboard--keyboard";
          kb_layout = "us,latam";
        }
        {
          name = "at-translated-set-2-keyboard";
          kb_layout = "us,latam";
        }
      ];

      windowrulev2 = [
        "noblur,class:(firefox)"
        "opacity 1 override,class:(firefox)"
        "opacity 0.85 override,class:(neovide)"
        "opacity 0.85 override,class:(kitty)"
        "opacity 0.9 override,class:(Spotify)"
        "opacity 0.97 override,class:(discord)"

        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
      ];

      # animation=NAME,ONOFF,SPEED,CURVE,STYLE Style optional
      bezier = [
        "curve,0.12, 0, 0.39, 0"
        "linear, 0.0, 0.0, 1.0, 1.0"
      ];

      animation = [
        "borderangle,1,150,linear,loop"
        "windows,1,2,default,popin"
        "fadeIn,1,3,default"
        "fadeOut,1,3,default"
        "workspaces,1,2.5,default,slide"
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

        # Move focus with mainMod + arrow keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Switch workspaces with jk
        "$mainMod, j, workspace, e+1"
        "$mainMod, k, workspace, e-1"
        "$mainMod, s, swapactiveworkspaces, eDP-1 HDMI-A-1"

        # Move windows to another workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"

        # Switch keyboard layouts
        "$mainMod, code:65, exec, hyprctl switchxkblayout corsair-corsair-gaming-k70-lux-rgb-keyboard--keyboard next"
        "$mainMod, code:65, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next"

        # Misc
        "$mainMod, f, togglefloating,"
      ];

      bindr = [
        ",Print, exec, /home/caches/.dotfiles/scripts/captureScreen.sh"
        "Shift_R, Print,exec, /home/caches/.dotfiles/scripts/captureArea.sh"
        "SUPER, SUPER_L, exec, pkill rofi || rofi -show drun"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
