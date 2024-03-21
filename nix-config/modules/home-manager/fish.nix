{ inputs, pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = "fastfetch\n set -U fish_greeting\n alias nixrebuild='cd /home/caches/.dotfiles/nix-config/ && sudo nixos-rebuild switch --flake .#default'";
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };
 }
