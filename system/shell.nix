{ pkgs, ... }:

{
  # add user's shell into /etc/shells
  environment.shells = with pkgs; [
    bash
  ];

  # set user's default shell system-wide
  users.defaultUserShell = pkgs.bash;
}