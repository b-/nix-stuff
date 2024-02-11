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
    direnv
    gh
    git
    lunarvim
    rnix-lsp
  ];

  programs.fish.enable = true;

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [
      "homebrew/cask-fonts"
      "homebrew/services"
      "homebrew/cask-versions"
      #"majd/repo"
    ];

    # `brew install`
    # TODO Feel free to add your favorite apps here.
    brews = [
      "aria2" # download tool
      "atuin"
      "autojump"
      "bash"
      "bat"
      # "direnv"
      "golang"
      "just"
      "kubernetes-cli"
      "neovim"
      #"starship"
      "stow"
      "thefuck"
      "tree-sitter"

      # "font-0xproto-nerd-font"
      # "font-3270-nerd-font"
      # "font-agave-nerd-font"
      # "font-anonymice-nerd-font"
      # "font-arimo-nerd-font"
      # "font-aurulent-sans-mono-nerd-font"
      "font-bigblue-terminal-nerd-font"
      # "font-bitstream-vera-sans-mono-nerd-font"
      # "font-blex-mono-nerd-font"
      # "font-caskaydia-cove-nerd-font"
      # "font-caskaydia-mono-nerd-font"
      "font-code-new-roman-nerd-font"
      # "font-comic-shanns-mono-nerd-font"
      # "font-commit-mono-nerd-font"
      "font-cousine-nerd-font"
      # "font-d2coding-nerd-font"
      # "font-daddy-time-mono-nerd-font"
      # "font-dejavu-sans-mono-nerd-font"
      # "font-droid-sans-mono-nerd-font"
      # "font-envy-code-r-nerd-font"
      # "font-fantasque-sans-mono-nerd-font"
      # "font-fira-code-nerd-font"
      # "font-fira-mono-nerd-font"
      # "font-geist-mono-nerd-font"
      # "font-go-mono-nerd-font"
      # "font-gohufont-nerd-font"
      # "font-hack-nerd-font"
      # "font-hasklug-nerd-font"
      # "font-heavy-data-nerd-font"
      # "font-hurmit-nerd-font"
      # "font-im-writing-nerd-font"
      # "font-inconsolata-go-nerd-font"
      # "font-inconsolata-lgc-nerd-font"
      # "font-inconsolata-nerd-font"
      # "font-intone-mono-nerd-font"
      # "font-iosevka-nerd-font"
      "font-iosevka-term-nerd-font"
      "font-iosevka-term-slab-nerd-font"
      "font-jetbrains-mono-nerd-font"
      # "font-lekton-nerd-font"
      # "font-liberation-nerd-font"
      # "font-lilex-nerd-font"
      # "font-martian-mono-nerd-font"
      # "font-meslo-lg-nerd-font"
      # "font-monaspace-nerd-font"
      # "font-monocraft-nerd-font"
      # "font-monofur-nerd-font"
      # "font-monoid-nerd-font"
      # "font-mononoki-nerd-font"
      # "font-mplus-nerd-font"
      # "font-noto-nerd-font"
      # "font-open-dyslexic-nerd-font"
      # "font-overpass-nerd-font"
      # "font-profont-nerd-font"
      # "font-proggy-clean-tt-nerd-font"
      # "font-roboto-mono-nerd-font"
      # "font-sauce-code-pro-nerd-font"
      "font-shure-tech-mono-nerd-font"
      # "font-space-mono-nerd-font"
      # "font-symbols-only-nerd-font"
      # "font-terminess-ttf-nerd-font"
      # "font-tinos-nerd-font"
      # "font-ubuntu-mono-nerd-font"
      # "font-ubuntu-nerd-font"
      "font-victor-mono-nerd-font"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      "1password"
      "1password-cli"
      "86box"
      "betterTouchTool"
      "discord"
      "google-chrome"
      "istat-menus"
      "iterm2"
      "jetbrains-toolbox"
      "karabiner-elements"
      "keybase"
      "microsoft-office"
      "visual-studio-code"
    ];
    masApps = {
      # "1Password for Safari" = 1569813296; # disabled, beta managed by testflight
      "Ghostery" = 1436953057;
      "Ivory" = 6444602274;
      "Jump Desktop" = 524141863;
      "Prompt" = 1594420480;
      "Refined GitHub" = 1519867270;
      "TestFlight" = 899247664;
      "Termius" = 1176074088;
      "Apple Configurator" = 1037126344;
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
