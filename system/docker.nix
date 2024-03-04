{ pkgs, ... }:

{
  virtualisation = {
    # enable docker
    docker = {
      enable = true;
      # start dockerd on boot.
      # This is required for containers which are created with the `--restart=always` flag to work.
      enableOnBoot = true;
    };
  };
}