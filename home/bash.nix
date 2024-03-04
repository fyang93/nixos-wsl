{ config, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = "krabby random 1-3 | tail -n +2";
  };
}