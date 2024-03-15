{ pkgs, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    initExtraFirst = "krabby random 1-3 | tail -n +2" + "\n" + (builtins.readFile ./zshrc);
  };
}