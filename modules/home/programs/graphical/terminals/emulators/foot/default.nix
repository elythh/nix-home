{
  config,
  pkgs,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.${namespace}.programs.terminal.emulators.foot;
in
{
  options.${namespace}.programs.terminal.emulators.foot = {
    enable = mkEnableOption "Wether to enable the foot terminal emulator";
  };

  config = mkIf cfg.enable {
    home.sessionVariables.TERMINAL = "foot";
    programs.foot = {
      enable = true;
      server.enable = false;
      settings = {
        main = {
          app-id = "foot";
          title = "foot";
          locked-title = "no";
          term = "xterm-256color";
          vertical-letter-offset = "-0.75";
          pad = "12x21 center";
          resize-delay-ms = 100;
          notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
          selection-target = "primary";
          # box-drawings-uses-font-glyphs = "yes";
          bold-text-in-bright = "no";
          word-delimiters = ",│`|:\"'()[]{}<>";
        };
        cursor = {
          style = "beam";
          beam-thickness = 2;
        };
        scrollback = {
          lines = 10000;
          multiplier = 3;
        };

        bell = {
          urgent = "yes";
          notify = "yes";
          command = "notify-send bell";
          command-focused = "no";
        };
        url = {
          launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
          protocols = "http, https, ftp, ftps, file, gemini, gopher, irc, ircs";

          uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
        };
        mouse = {
          hide-when-typing = "yes";
        };
        key-bindings = {
          show-urls-launch = "Control+Shift+u";
          unicode-input = "Control+Shift+i";
        };
        mouse-bindings = {
          selection-override-modifiers = "Shift";
          primary-paste = "BTN_MIDDLE";
          select-begin = "BTN_LEFT";
          select-begin-block = "Control+BTN_LEFT";
          select-extend = "BTN_RIGHT";
          select-extend-character-wise = "Control+BTN_RIGHT";
          select-word = "BTN_LEFT-2";
          select-word-whitespace = "Control+BTN_LEFT-2";
          #select-row = "BTN_LEFT-3";
        };
      };
    };
  };
}