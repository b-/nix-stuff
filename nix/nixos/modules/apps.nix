{ self
, lib
, pkgs
, unstable
, username
, ...
}:

{
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
    polkitPolicyOwners = [ "${username}" ];
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
  programs.mtr.enable = true;

}