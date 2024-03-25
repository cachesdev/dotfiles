{ config, pkgs, inputs, ... }:

{

  imports = [
    ../../modules/home-manager/monitors.nix
    ../../modules/home-manager/fish.nix
    ../../modules/home-manager/hyprland/hyprland.nix
  ];

  home.username = "caches";
  home.homeDirectory = "/home/caches";

  # Direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
      y = 0;
      enabled = true;
    }
    {
      name = "HDMI-A-1";
      width = 2560;
      height = 1080;
      refreshRate = 60;
      x = 1920;
      y = 0;
      enabled = true;
    }
  ];


  # Set Dark Theme
  gtk = {
    enable = true;
    theme.package = pkgs.tokyonight-gtk-theme;
    theme.name = "Tokyonight-Dark-BL";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };


  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

  # Global Python3

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  # Environment Variables
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
