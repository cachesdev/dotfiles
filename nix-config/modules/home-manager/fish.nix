{ inputs, pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
    fastfetch
    set -U fish_greeting
    alias man='batman'
    alias nixrebuild='cd /home/caches/.dotfiles/nix-config/ && sudo nixos-rebuild switch --flake .#default'
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };
 }
