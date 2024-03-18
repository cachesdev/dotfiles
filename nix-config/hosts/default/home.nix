{ config, pkgs, inputs, ... }:

{

  imports = [
    ../../modules/home-manager/monitors.nix
    ../../modules/home-manager/hyprland/hyprland.nix
  ];

  home.username = "caches";
  home.homeDirectory = "/home/caches";

  monitors = [
    {
      name = "Internal";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
      y = 0;
      enabled = true;
    }
    {
      name = "HDMI";
      width = 2560;
      height = 1080;
      refreshRate = 60;
      x = 0;
      y = 0;
      enabled = true;
    }
  ];
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

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
