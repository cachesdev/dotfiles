{ inputs, pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
    fastfetch
    set -U fish_greeting
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
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
