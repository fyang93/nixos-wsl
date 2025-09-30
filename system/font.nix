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
}