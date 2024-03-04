{ catppuccin-starship, ...}: {
  programs.starship = {
    enable = true;

    enableBashIntegration = true;

    settings = {
      palette = "catppuccin_mocha";
    } // builtins.fromTOML (builtins.readFile "${catppuccin-starship}/palettes/mocha.toml");
  };
}

