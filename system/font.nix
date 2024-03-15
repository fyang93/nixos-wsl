{ config, pkgs, ... }:

{
  # custom fonts
  fonts = {
    enableDefaultPackages = false;
    fontDir.enable = true;

    packages = with pkgs; [
      sarasa-gothic
      noto-fonts-emoji
    ];

    fontconfig.defaultFonts = {
      serif = ["Sarasa UI SC" "Noto Color Emoji"];
      sansSerif = ["Sarasa UI SC" "Noto Color Emoji"];
      monospace = ["Sarasa Mono SC" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };

    fontconfig.localConf = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <!--Microsoft YaHei, SimHei, SimSun -->
      <match target="pattern">
        <test qual="any" name="family">
          <string>Microsoft YaHei</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Sarasa UI SC</string>
        </edit>
      </match>
      <match target="pattern">
        <test qual="any" name="family">
          <string>SimHei</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Sarasa UI SC</string>
        </edit>
      </match>
      <match target="pattern">
        <test qual="any" name="family">
          <string>SimSun</string>
        </test>
        <edit name="family" mode="assign" binding="same">
          <string>Sarasa UI SC</string>
        </edit>
      </match>
    '';
  };

  ###################################################################################
  #
  #  Copy from https://github.com/NixOS/nixpkgs/issues/119433#issuecomment-1326957279
  #  Mainly for flatpak
  #    1. bindfs resolves all symlink,
  #    2. allowing all fonts to be accessed at `/usr/share/fonts`
  #    3. without letting /nix into the sandbox.
  #
  ###################################################################################

  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
  in {
    # Create an FHS mount to support flatpak host icons/fonts
    "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
}