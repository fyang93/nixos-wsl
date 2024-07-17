{ pkgs, config, nushell-scripts, ...}: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = "nu";
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;

    extraConfig = ''
      $env.PATH = ([
        "${config.home.homeDirectory}/bin"
        "${config.home.homeDirectory}/.local/bin"
        ($env.PATH | split row (char esep))
      ] | flatten)
      use ${nushell-scripts}/custom-completions/git/git-completions.nu *
      use ${nushell-scripts}/custom-completions/make/make-completions.nu *
      use ${nushell-scripts}/custom-completions/nix/nix-completions.nu *
      use ${nushell-scripts}/custom-completions/cargo/cargo-completions.nu *
      use ${nushell-scripts}/custom-completions/zellij/zellij-completions.nu *

      krabby random 1-3 | tail -n +2
    '';

    # home-manager will merge the content in `environmentVariables` with the `envFile.source`
    # but basically, I set all environment variables via the shell-independent way, so I don't need to use those two options
    #
    # envFile.source = ./env.nu;
    # environmentVariables = { FOO="bar"; };

    shellAliases = {
    };
  };
}