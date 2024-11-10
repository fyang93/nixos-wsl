{ pkgs, lib, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
  };

  # environment.variables = {
  #   LD_LIBRARY_PATH = "/run/opengl-driver/lib";
  # };
}