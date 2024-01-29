{ pkgs, lib, ... }: {

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    comma
    git
    rnix-lsp
  ];

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      # cleanup = "zap";
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "aria2" # download tool
      "atuin"
      "autojump"
      "bash"
      "bat"
      "direnv"
      "golang"
      "just"
      "kubernetes-cli"
      "neovim"
      "starship"
      "stow"
      "thefuck"
      "tree-sitter"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "1password"
      "1password-cli"
      "discord"
      "google-chrome"
      "iterm2"
      "jetbrains-toolbox"
      "karabiner-elements"
      "microsoft-office"
      "visual-studio-code"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Ghostery" = 1436953057;
      "Ivory" = 6444602274;
      "Jump Desktop" = 524141863;
      "Prompt" = 1594420480;
      "Refined GitHub" = 1519867270;
      "TestFlight" = 899247664;
    };
  };
  # Enable select unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password"
    "1password-cli"
    "discord"
    "google-chrome"
    "vscode"
  ];
}
