{pkgs, ...}:

{
  hardware = {
    nvidia.open = true;
    nvidia-container-toolkit = {
      enable = true;
      mount-nvidia-executables = false; # https://github.com/nix-community/NixOS-WSL/issues/578
      suppressNvidiaDriverAssertion = true;
    };
  };
}