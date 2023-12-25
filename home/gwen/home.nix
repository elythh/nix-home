{ inputs, config, pkgs, lib, nix-colors, spicetify-nix, polymc, nixpkgs-f2k, ... }:

let
  theme = "cat";
  hyprland-plugins = inputs.hyprland-plugins;
  zjstatus = inputs.zjstatus;
  anyrun = inputs.anyrun;
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/master.tar.gz")
    {
      config = config.nixpkgs.config;
    };
in
{
  # some general info
  home.username = "gwen";
  home.homeDirectory = "/home/gwen";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    bash.enable = true; # see note on other shells below
  };

  home.file.".icons/default".source =
    "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
  # gtk themeing
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "Reversal-dark";
    theme.name = "phocus";
    font = {
      name = "Lexend";
      size = 11;
    };
  };

  # The global colorScheme, used by most apps
  colorScheme =
    {
      colors = import ../shared/cols/${theme}.nix { };
      name = "${theme}";
    };

  imports = [
    #import ./conf/ui/hyprland/default.nix

    nix-colors.homeManagerModules.default
    # Importing Configurations
    ./conf/music/cava
    ./conf/music/spicetify
    ./conf/shell/zsh
    ./conf/term/kitty/default.nix
    ./conf/term/wezterm/default.nix
    ./conf/term/zellij
    ./conf/utils/dunst/default.nix
    ./conf/utils/gpg-agent/default.nix
    ./conf/utils/k9s/default.nix
    ./conf/utils/lf/default.nix
    ./conf/utils/picom
    ./conf/utils/rofi/default.nix
    ./conf/utils/spotifyd/default.nix
    ./misc/neofetch.nix
    ./misc/vencord.nix
    ./misc/xinit.nix
    # Bin files
    ../shared/bin/default.nix
    ../shared/lock.nix
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch awesome-v2 https://github.com/elythh/nixdots ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/elythh/nvim ${config.home.homeDirectory}/.config/nvim
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/zsh" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch zsh https://github.com/elythh/dotfiles ${config.home.homeDirectory}/.config/zsh
        fi
      '';
    };
    packages = with pkgs; [
      (pkgs.callPackage ../../derivs/phocus.nix { inherit config nix-colors; })
      (pkgs.callPackage ../../derivs/gruv.nix { })
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../shared/icons/reversal.nix { })
      (discord.override {
        withVencord = true;
      })
      zjstatus.packages.${system}.default
      acpi
      android-tools
      arandr
      awscli
      betterdiscordctl
      bitwarden
      bluez
      bluez-alsa
      bluez-tools
      brave
      btop
      cava
      chatterino2
      chromium
      colordiff
      dig
      dmenu
      docker-compose
      dunst
      easyeffects
      eza
      feh
      ffmpeg_5-full
      fzf
      gcc
      git-lfs
      glib
      glow
      gnumake
      gnupg
      go
      google-cloud-sdk
      helmfile
      hyprland-autoname-workspaces
      hyprpicker
      i3lock-fancy
      jellyfin-media-player
      jq
      jqp
      just
      k9s
      krew
      kubecolor
      kubectl
      kubernetes-helm
      kubie
      lazygit
      light
      lxappearance-gtk2
      ncdu
      neovim
      networkmanagerapplet
      niv
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-json-languageserver
      obs-studio
      obsidian
      ollama
      openssl
      openvpn
      pass
      pavucontrol
      pfetch
      pinentry
      playerctl
      procps
      python311Packages.gst-python
      python311Packages.pip
      python311Packages.pygobject3
      python311Packages.setuptools
      python311Packages.virtualenv
      rbw
      ripgrep
      rofi-pass
      rofi-rbw
      rustup
      scrcpy
      skim
      slack
      slides
      starship
      stern
      stremio
      syncthing
      telegram-desktop
      thunderbird
      tree-sitter
      vault
      wget
      wireplumber
      xcolor
      xh
      xorg.xrandr
      yarn
      yazi
      yq
      zellij
      zoxide
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}

