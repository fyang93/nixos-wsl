{ pkgs, ... }:

{
  virtualisation = {
    # enable docker
    docker = {
      enable = true;
      # start dockerd on boot.
      # This is required for containers which are created with the `--restart=always` flag to work.
      enableOnBoot = true;

      # nvidia support
      enableNvidia = true;
    };
  };

  # libnvidia-container does not support cgroups v2 (prior to 1.8.0)
  # https://github.com/NVIDIA/nvidia-docker/issues/1447
  systemd.enableUnifiedCgroupHierarchy = false;
}