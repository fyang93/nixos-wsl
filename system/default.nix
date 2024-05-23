{ pkgs, pkgs-stable, ... }:

{
  imports = [
    ./system.nix
    ./user.nix
    ./font.nix
    ./ssh.nix
    ./shell.nix
    ./python.nix
    ./docker.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # helix # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    # git
    # git-lfs
    psmisc  # killall/pstree/prtstat/fuser/...
    tldr # simple man pages

    # archive
    ouch
    zip
    xz
    unzip
    p7zip
    zstd
    gnutar

    # nodejs
    nodePackages.nodejs
    nodePackages.npm
    yarn

    # used by pyppeteer
    pkgs-stable.chromium
  ];

  programs = {
    adb.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
  };
}
