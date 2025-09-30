{ pkgs, lib, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      daemon.settings = {
        registry-mirrors = [
          "https://docker.1panel.live"
          "https://docker.1ms.run"
          "https://docker.m.daocloud.io"
        ];
      };
    };
  };
}
