{ inputs, pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fastfetch
      set -U fish_greeting
      alias man='batman'
      alias nixrebuild='cd /home/caches/.dotfiles/nix-config/ && sudo nixos-rebuild switch --flake .#default'
      set -gx PATH $PATH $HOME/go/bin
      set -gx PATH $PATH $HOME/.node_modules/bin
      set -Ux TERM xterm-256color

      function runbg
          set -l cmd $argv
          nohup $cmd > /dev/null 2>&1 &
          disown
          echo "Iniciado $cmd en el fondo"
      end

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
