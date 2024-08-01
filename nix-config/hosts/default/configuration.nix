#gEdit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/hyprland.nix
      # ./secrets.nix
      inputs.home-manager.nixosModules.default
    ];

  # Substituters
  nix.settings = {
    trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
    trusted-substituters = [ "https://devenv.cachix.org" ];
  };

  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Default Shell
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Asuncion";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_PY.UTF-8";
    LC_IDENTIFICATION = "es_PY.UTF-8";
    LC_MEASUREMENT = "es_PY.UTF-8";
    LC_MONETARY = "es_PY.UTF-8";
    LC_NAME = "es_PY.UTF-8";
    LC_NUMERIC = "es_PY.UTF-8";
    LC_PAPER = "es_PY.UTF-8";
    LC_TELEPHONE = "es_PY.UTF-8";
    LC_TIME = "es_PY.UTF-8";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ 
      inputs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.startx.enable = true;
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Polkit KDE Auth
  security.polkit.enable = true;

  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "hyprland-session.target" ];
      wants = [ "hyprland-session.target" ];
      after = [ "hyprland-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Java
  programs.java.package = pkgs.jdk;
  programs.java.enable = true;

  # Power Management
  services.power-profiles-daemon.enable = false; # Disable default power management
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      # iGPU
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
    };
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.caches = {
    isNormalUser = true;
    description = "Gustavo Dominguez";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "caches" = import ./home.nix;
    };
  };

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "caches";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # path I tihnk
  environment.variables = {
    PATH = [ "/home/caches/Documents/repos/fresco" ];
  };

  # plex
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "caches";
  };

  # Automount
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Firebird
# services.firebird = {
#       enable = true;
#       package = pkgs.firebird_2_5;
#     };

networking.firewall = {
  enable = true;
  allowedTCPPorts = [ 5173 ];
  allowedUDPPortRanges = [
    { from = 5172; to = 5173; }
  ];
};

  # MySql
  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql80;

  nixpkgs.overlays = [
    (self: super: {
      mblock-mlink = super.callPackage ../../drv/mblock-mlink.nix { };
    })
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    (pkgs.makeDesktopItem {
      type = "Application";
      exec = "neovide --grid 80x24";
      icon = "neovide";
      name = "NeovideFix";
      keywords = [ "editor" "neovim" "vim" "rust" ];
      categories = [ "Utility" "TextEditor" ];
      comment = "No Nonsense Neovim Client In Rust";
      mimeTypes = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
      desktopName = "NeovideFix";
      genericName = "GUI Frontend";
    })
    (pkgs.ventoy.override { withGtk3 = true; })
    oculante
    jetbrains.datagrip
    vscode-langservers-extracted
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    qbittorrent
    go-tools
    vesktop
    powertop
    gopls
    google-chrome
    cobra-cli
    lazygit
    eclipses.eclipse-java
    # polkit_gnome
    networkmanager
    gnome-themes-extra
    webcord
    gnome-tweaks
    anki
    zed-editor
    gh
    libsForQt5.polkit-kde-agent
    xwaylandvideobridge
    dunst
    parsec-bin
    killall
    gcc
    lf
    mc
    file
    sshfs
    realvnc-vnc-viewer
    (neovim.override {
      withNodeJs = true;
      withPython3 = true;
      extraPython3Packages = ps: with ps; [
        pynvim
        python-dotenv
        requests
        prompt-toolkit
        pyqt6
      ];
    })
    (pkgs.python3.withPackages (ps: with ps; [ pip pyqt6 ]))
    kdePackages.qtwayland
    mysql-workbench
    sshocker
    dolphin
    rar
    neovide
    obsidian
    git
    bat
    unzip
    ripgrep
    nodejs
    nodePackages.eslint
    go
    rustc
    cargo
    lua-language-server
    home-manager
    prusa-slicer
    xclip
    wl-clipboard
    lshw
    kitty
    waybar
    obs-studio
    grim
    swww
    waypaper
    playerctl
    dolphin
    pavucontrol
    rofi-wayland
    wev
    slurp
    sox
    spotify
    stress
    nixpkgs-fmt
    lua
    luajitPackages.luarocks
    fastfetch
    btop
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-powerlevel10k
    bat-extras.batman
    ifwifi
    jetbrains.idea-ultimate
    onlyoffice-bin
    wget
    github-copilot-intellij-agent
    cloc
    jdk17
    zsh
    cinnamon.nemo-with-extensions
    brightnessctl
    prismlauncher
    fzf
    vscode-fhs
    yt-dlp
    ed
    zoxide
    discord
    # Flameshot with Wayland support
    (pkgs.flameshot.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "flameshot-org";
        repo = "flameshot";
        rev = "fa29bcb4279b374ea7753fc4a514fd705499f7e7";
        sha256 = "sha256-XIquratzK4qW0Q1ZYI5X6HIrnx1kTTFxeYeR7hjrpjQ=";
      };
      cmakeFlags = [
        "-DUSE_WAYLAND_GRIM=True"
        "-DUSE_WAYLAND_CLIPBOARD=1"
      ];
      buildInputs = with pkgs; [ libsForQt5.kguiaddons ];
    })
  ];

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    (nerdfonts.override { fonts = [ "CascadiaCode" "Go-Mono"]; })
    corefonts
    atkinson-hyperlegible
  ];









  system.stateVersion = "23.11"; # Did you read the comment?

}
