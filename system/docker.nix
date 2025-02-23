{ pkgs, lib, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      daemon.settings.registry-mirrors = [
        "https://docker.mirrors.ustc.edu.cn"
        "https://docker.nju.edu.cn"
      ];
    };
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
    mount-nvidia-executables = false;
  };
}