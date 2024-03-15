{...}: {
  programs.zellij = {
    enable = true;
    # enableBashIntegration = true;
  };

  home.file.".config/zellij/config.kdl".source = ./config.kdl;
}