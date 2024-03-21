# Edit this configuration file to define what should be installed on
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
      inputs.home-manager.nixosModules.default
    ];

  # Experimental
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


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

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ inputs.xdg-desktop-portal-hyprland ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "caches";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    neovim
    lf
    neovide
    git
    bat
    unzip
    ripgrep
    nodejs
    go
    rustc
    cargo
    lua-language-server
    android-tools
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
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.pygobject3
    ]))
    gobject-introspection
    playerctl
    python311Packages.pip
    dolphin
    pavucontrol
    rofi-wayland
    wev
    slurp
    sox
    spotify
    stress
    nixpkgs-fmt
    fastfetch
    btop
    inputs.walker
    (pkgs.discord.override {
      withVencord = true;
    })

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
    (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
  ];


  system.stateVersion = "23.11"; # Did you read the comment?

}
