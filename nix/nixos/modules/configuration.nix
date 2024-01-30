# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, options, unstable, ... }:

let
  cde-icons = pkgs.writeShellScriptBin "cde-icons" ''
    file=`basename ''${1%.*}`

    ${pkgs.imagemagick}/bin/convert $1 -resize 48x48 ~/.dt/icons/$file.l.pm
    ${pkgs.imagemagick}/bin/convert $1 -resize 32x32 ~/.dt/icons/$file.m.pm
    ${pkgs.imagemagick}/bin/convert $1 -resize 24x24 ~/.dt/icons/$file.s.pm
    ${pkgs.imagemagick}/bin/convert $1 -resize 16x16 ~/.dt/icons/$file.t.pm
  '';
  cde-battery = pkgs.writeScriptBin "cde-battery" ''
    #!${pkgs.cdesktopenv}/opt/dt/bin/dtksh
    ${pkgs.lib.readFile (pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/edorig/dtksh/5f49e402b391c81ebea9609bdec9c7716e70a8c0/battery";
      sha256 = "0zjn9zl1as9xbk2845bbdy2xfj29b4hvvalcz8kf2llkndbfswvl";
    })}
  '';
in {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Flakes and the new command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chromebook-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.cde.enable = true;
  services.xserver.desktopManager.cde.extraPackages = with pkgs;
    options.services.xserver.desktopManager.cde.extraPackages.default ++ [
      fsv
      cde-icons
      #cde-gtk-theme
      cde-battery
    ];


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bri = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "bri";
    extraGroups = [ "networkmanager" "wheel" ];
    ###
    #### user pkgs ####
    ###
    packages = with pkgs; [
      firefox
      kate
      vscode
      #  thunderbird
    ];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  programs.dconf.enable = true;

  # Enable select unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "1password-cli"
    "discord"
    "google-chrome"
    "vscode"
  ];


  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    package = pkgs._1password-gui-beta;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "bri" ];
  };

  ###
  ####PACKAGES####
  ###
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    just
    neovim
    stow
    vim
    wget
  ];

  services.tailscale.enable = true;

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


  #----=[ Fonts ]=----#
  fonts = {
    enableDefaultPackages = true;

    fontconfig = {
      defaultFonts = {
        #serif = [ "Ubuntu" ];
        #sansSerif = [ "Ubuntu" ];
        # monospace = [ "PragmataPro Liga" ];
        monospace = [ "Berkeley Mono" ];
      };
    };
  };
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          #libsForQt5.breeze-qt5  # for plasma
          gnome.gnome-themes-extra
        ];
        pathsToLink = [ "/share/icons" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}