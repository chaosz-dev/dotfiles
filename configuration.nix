# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tartarus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
	videoDrivers = ["nvidia"];
	displayManager.gdm = {
		enable = true;
		wayland = true;
	};
  };
  programs.hyprland = {
    enable = true;
    xwayland.enable = true; 
    nvidiaPatches = true;
  };
 
  #programs.waybar.enable = true;

  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "hu";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "hu";

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.upower.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chaosz = {
    isNormalUser = true;
    description = "chaosz";
    extraGroups = [ "networkmanager" "wheel" "vboxusers"  ];
    packages = with pkgs; [
      firefox
      vim
      gcc
      vscode
      kitty
      alacritty
      alacritty-theme
      discord
      chromium
      microsoft-edge
      google-chrome
      spotify	
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.opengl.driSupport32Bit = true;

  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.chaosz = {pkgs, ...}: {
    home.packages = with pkgs; [
	git
    ];
    programs.bash = {
      enable = true;
      initExtra = ''
        source ~/dotfiles/scripts/.git-colorful.sh
        source ~/dotfiles/scripts/walrusScripts.sh
      '';
    };    

    programs.alacritty = {
      enable = true;
      settings = {
	window.opacity = 0.65;
        colors = {
          primary = {
	    background = "#000000";
	    foreground = "#FFFFFF";
	  };
 	  normal = {
	    black = "#1a1a1a";
	    red = "#f4005f";
	    green = "#98e024";
	    yellow = "#fa8419";
	    blue = "#9d65ff";
	    magenta = "#f4005f";
	    cyan = "#58d1eb";
	    white = "#c4c5b5";
	  };
	  bright = {
	    black = "#625e4c";
	    red = "#f4005f";
	    green = "#98e024";
	    yellow = "#e0d561";
	    blue = "#9d65ff";
            magenta = "#f4005f";
	    cyan = "#58d1eb";
	    white = "#f6f6ef";
	  };
        }; 
      };
    };
    home.stateVersion = "23.11";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    rofi
    hyprpaper
    cachix
    vim
    wget
    pkg-config
    gcc
    gcc_multi
    pkgsi686Linux.gcc
    pkgsi686Linux.glib
    pkgsi686Linux.glibc
    pkgsi686Linux.glibc_multi
    glib
    glibc
    glibc_multi
    gobject-introspection
    cmake
    ninja
    atk
    rustup
    rustc
    cargo
    gdk-pixbuf
    gtk3
    pipewire
    wireplumber
    dunst
    glib
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    polkit-kde-agent
    neofetch
  ];

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    allowReboot = true;
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  nixpkgs.config.virtualbox.enableExtensionPack = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
