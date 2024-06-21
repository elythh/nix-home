{
  inputs,
  pkgs,
  ...
}: {
  theme = "aquarium";

  imports = [
    inputs.anyrun.homeManagerModules.default
    ../../modules/home
  ];

  modules = {
    anyrun.enable = true;
    hyprland.enable = true;
    k9s.enable = true;
    lazygit.enable = true;
    rofi.enable = true;
    rbw.enable = true;
    spicetify.enable = true;
    sss.enable = true;
    zellij.enable = true;
    zsh.enable = true;
  };

  default = {
    de = "hyprland";
    bar = "waybar";
    lock = "hyprlock";
    terminal = "wezterm";
  };

  var.theme = import ../shared/themes/nixy.nix;

  home = {
    packages = with pkgs; [
      (discord.override {withVencord = true;})
      scrcpy
      stremio
      yazi
      showmethekey
    ];
  };
}
