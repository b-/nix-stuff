{ self
, lib
, pkgs
, unstable
, username
, nix-software-center
, nixos-conf-editor
, ...
}:

{
  programs = {
  zsh.enable = true;
  fish.enable = true;

  dconf.enable = true;

  _1password.enable = true;
  _1password-gui = {
    enable = true;
    package = pkgs._1password-gui-beta;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "${username}" ];
  };

  # mtr traceroute
  mtr.enable = true;
  };

  # Enable select unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "1password-cli"
    "discord"
    "google-chrome"
    "vscode"
  ];



  ###
  ####PACKAGES####
  ###
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #nixos-conf-editor.packages.${system}.nixos-conf-editor
    #nix-software-center.packages.${system}.nix-software-center

    deploy-rs
    git
    just
    ncdu
    neovim
    rnix-lsp
    stow
    vim
    wget
  ];

  #### user pkgs ####
  users.users."${username}".packages = with pkgs; [
    firefox
    kate
    tor-browser-bundle-bin
    vscode
    #  thunderbird
  ];


  services.tailscale.enable = true;

}
