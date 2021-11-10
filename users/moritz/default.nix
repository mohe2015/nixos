{ pkgs, ... }:
{
  home-manager.users.moritz = {
    imports = [ ../profiles/git ../profiles/direnv ../profiles/gpg ];

    programs.git = {
      userName = "mohe2015";
      userEmail = "Moritz.Hedtke@t-online.de";
      signing.signByDefault = true;
      signing.key = "1248D3E11D114A8575C989346794D45A488C2EDE";
    };

    home.file.".npmrc".text = ''
      prefix=/home/moritz/.npm
      ignore-scripts=true
    '';

    wayland.windowManager.sway = {
      enable = true;
      xwayland = false;
      wrapperFeatures.gtk = true;
      config = {
        menu = "wofi --show run";
        input = { "*" = { xkb_layout = "de"; } ; };
        bars = [{
          command = "${pkgs.waybar}/bin/waybar";
        }];
      };
      extraConfig = ''
        xwayland disable

        bindsym XF86MonBrightnessDown exec "${pkgs.brightnessctl}/bin/brightnessctl set 2%-"
        bindsym XF86MonBrightnessUp exec "${pkgs.brightnessctl}/bin/brightnessctl set +2%"

        bindsym XF86AudioRaiseVolume exec '${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%'
        bindsym XF86AudioLowerVolume exec '${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%'
        bindsym XF86AudioMute exec '${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle'
        bindsym XF86AudioMicMute exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle
      '';
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
    };

    programs.bash.enable = true;

    home.packages = with pkgs; [
      wf-recorder
      swaylock
      swayidle
      wl-clipboard
      mako # notification daemon
      alacritty # Alacritty is the default terminal in the config
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      slurp
      grim
      sway-contrib.grimshot

      alsaUtils

      virt-manager
      #pkgs.qjackctl
      #      pkgs.hcloud
      #      pkgs.wget
      #pkgs.veracrypt
      pkgs.tor-browser-bundle-bin
      #      pkgs.sqlite
      #      pkgs.sqlite.dev
      #      pkgs.pkg-config
      #      pkgs.binutils
      pkgs.plasma-systemmonitor
      pkgs.htop
      #      pkgs.kicad
      #pkgs.multimc
      #pkgs.minecraft
      #      pkgs.sshfs
      pkgs.rustup
      #      pkgs.gcc
      #pkgs.chromium
      #      pkgs.ktorrent
      pkgs.lyx
      #      pkgs.kmix
      #      pkgs.git-crypt
      pkgs.signal-desktop
      pkgs.xournalpp
      pkgs.thunderbird
      pkgs.firefox-wayland
      #      pkgs.eclipses.eclipse-java
      pkgs.git
      pkgs.git-lfs
      pkgs.gnupg
      pkgs.vlc
      (pkgs.vscode-with-extensions.override {
        vscode = (pkgs.vscode.override {
      /*commandLineArgs =
        "--enable-features=VaapiVideoDecoder,UseOzonePlatform " +
        "--enable-accelerated-video-decode " +
        "--ozone-platform=wayland " +
        "--enable-gpu-rasterization " +
        "--force-dark-mode " +
        "--enable-native-notifications";*/
    });
        vscodeExtensions = with pkgs.vscode-registries.openvsx.extensions; [ ms-vscode.cpptools jnoortheen.nix-ide mshr-h.VerilogHDL ];
      })
      (pkgs.chromium.override {
      /*commandLineArgs =
        "--enable-features=VaapiVideoDecoder,UseOzonePlatform " +
        "--enable-accelerated-video-decode " +
        "--ozone-platform=wayland " +
        "--enable-gpu-rasterization " +
        "--disable-sync-preferences " +
        "--force-dark-mode " +
        "--enable-native-notifications";*/
    })

        
      #pkgs.vscode
      pkgs.discord
      pkgs.libreoffice-still
      pkgs.texlive.combined.scheme-full
      #      pkgs.unzip
      pkgs.obs-studio
      #      pkgs.wireshark
      #pkgs.racket
      pkgs.hunspell
      pkgs.hunspellDicts.de-de
      pkgs.hunspellDicts.en-us
      #     pkgs.jetbrains.idea-community
      #     pkgs.jdk
      pkgs.ark
      pkgs.gh
      #pkgs.androidStudioPackages.canary
      # pkgs.pdfsam-basic
      #     pkgs.kubectl
      #      pkgs.krew
      #     pkgs.kubernetes-helm

      # https://gvolpe.com/blog/gnome3-on-nixos/
      # gnome3 apps
      #     gnome3.eog    # image viewer
      #     gnome3.evince # pdf reader

      # desktop look & feel
      #     gnome3.gnome-tweak-tool

      # extensions
      #      gnomeExtensions.appindicator
      #      gnomeExtensions.dash-to-dock
    ];

    #    programs.ssh = {
    #      enable = true;
    #startAgent = true;
    #    };

    #programs.fish = {
    #  enable = true;
    #};
  };

  programs.java = {
    enable = true;
  };

  programs.ssh = {
    startAgent = true;
  };

  users.users.moritz = {
    uid = 1000;
    hashedPassword = "$6$KycoTiPm3n.Mayc$7ZDSUvfXEP7zsyDGslx/C5HIbM.fZlfbK0ppsRHSbVNb6O8AqSbF1sjUsSkzEthDneean2fYtEQm.KGZYNbS.1";
    description = "default";
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" "docker" "adbusers" "scanner" "lp" "jackaudio" ];
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
}
