{ pkgs, lib, ... }:

{
  imports = [
    ./font.nix
    ./ssh.nix
    ./docker.nix
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    git-lfs
    tree
    psmisc # killall/pstree/prtstat/fuser/...
    dig # DNS lookup tool
    openssl

    # archive
    ouch
    zip
    xz
    unzip
    p7zip
    zstd
    gnutar

    # dev
    # nodejs
    nodePackages.nodejs
    nodePackages.npm
    typescript
    yarn
    # c
    cmake
    # python
    conda
    
    # web scrape
    playwright
    chromium
  ];

  programs = {
    adb.enable = true;
  };

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # Garbage collection.
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 1w";
  };

  nix.settings = {
    # Manual optimise storage: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # add user's shell into /etc/shells
  environment.shells = with pkgs; [
    bash
  ];

  # set user's default shell system-wide
  users.defaultUserShell = pkgs.bash;

  services.automatic-timezoned.enable = true;  # 自动时区
  services.timesyncd.enable = true;            # 时间同步
}
