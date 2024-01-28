{ pkgs, ...}: {

  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
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
      "aria2"  # download tool
      "atuin"
      "bash"
      "bat"
      # "ca-certificates"
      "direnv"
      # "gettext"
      "just"
      "kubernetes-cli"
      # "libgit2"
      # "libssh2"
      # "libtermkey"
      # "libuv"
      # "libvterm"
      # "luajit"
      # "luv"
      # "mpdecimal"
      # "msgpack"
      "neovim"
      # "nixpacks"
      # "oniguruma"
      # "openssl@3"
      # "python@3.12"
      # "readline"
      # "six"
      # "sqlite"
      "starship"
      "stow"
      "thefuck"
      "tree-sitter"
      # "unibilium"
      # "xz"
    ];

    # `brew install --cask`
    # TODO Feel free to add your favorite apps here.
    casks = [
      # "google-chrome"
      "1password-cli"
      "iterm2"
      "discord"
    ];
  };
}
