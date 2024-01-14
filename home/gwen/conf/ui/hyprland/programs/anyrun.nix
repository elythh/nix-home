{ pkgs, config, inputs, ... }:
{
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system};
        [
          applications
          randr
          rink
          shell
          symbols
          translate
        ];

      width.fraction = 0.5;
      y.absolute = 15;
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = 10;
    };

    extraCss =
      let
        xcolors = config.colorscheme.colors;
      in
      ''
        * {
          all: unset;
          border: none;
          border-radius: 0;
          min-height: 0;
          min-width: 0;
          font-family: Dosis, sans-serif;
          font-size: 1.3rem;
        }

        #entry,
        #window,
        #main,
        #plugin,
        #match {
          background: transparent;
        }

        #entry {
          border: 1px solid #${xcolors.darker};
          border-radius: 8px;
          margin: 0.5rem;
          padding: 0.3rem 1rem;
        }

        #plugin,
        #match.activatable {
          border-radius: 8px;
          padding: 0.3rem;
        }

        #match.activatable:first-child {
          margin-top: 0.5rem;
        }

        #match.activatable:last-child {
          margin-bottom: 0.5rem;
        }

        #match:selected,
        #match:hover,
        #plugin:hover {
          background: alpha(#${xcolors.color4}, 0.5);
          border: 1px solid #${xcolors.color4};
          color: #${xcolors.color4};
        }

        box#main {
          background: #${xcolors.background};
          border-radius: 12px;
          padding: 0.3rem;
        }
      '';

    extraConfigFiles = {
      "applications.ron".text = ''
        Config(
          desktop_actions: true,
          max_entries: 10,
          terminal: Some("kitty"),
        )
      '';

      "translate.ron".text = ''
        Config(
          prefix: ":tr",
          language_delimiter: ">",
          max_entries: 5,
        )
      '';
    };
  };
}