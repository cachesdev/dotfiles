{ inputs, pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fastfetch
      set -U fish_greeting
      alias man='batman'
      alias nixrebuild='cd /home/caches/.dotfiles/nix-config/ && sudo nixos-rebuild switch --flake .#default'
      set -gx PATH $PATH $HOME/go/bin
    '';
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };
}
