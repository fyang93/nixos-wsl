{ pkgs, ... }:

{
  # add user's shell into /etc/shells
  environment.shells = with pkgs; [
    bash
    zsh
  ];

  # enable zsh
  programs.zsh = {
    enable = true;
  };

  # set user's default shell system-wide
  users.defaultUserShell = pkgs.zsh;
}