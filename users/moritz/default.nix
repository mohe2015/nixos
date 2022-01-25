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

    #home.file.".npmrc".text = ''
    #  prefix=/home/moritz/.npm
    #  ignore-scripts=true
    #'';

    wayland.windowManager.sway = {
      enable = true;
      xwayland = false;
      wrapperFeatures.gtk = true;
      config = {
        menu = "wofi --show run";
        input = { "*" = { xkb_layout = "de"; }; };
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

    programs.chromium.enable = true;

    home.packages = with pkgs; [
      nixpkgs-review
      #nixos-nspawn
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
      pkgs.minecraft
      #      pkgs.sshfs
      pkgs.rustup
      #pkgs.clang_13
      pkgs.gcc
      pkgs.gdb
      #pkgs.chromium
      #      pkgs.ktorrent
      pkgs.lyx
      #      pkgs.kmix
      #      pkgs.git-crypt
      pkgs.signal-desktop
      pkgs.xournalpp
      pkgs.thunderbird
      pkgs.firefox-bin #-wayland
      #      pkgs.eclipses.eclipse-java
      pkgs.git
      pkgs.git-lfs
      pkgs.gnupg
      pkgs.vlc
      
    #  (pkgs.vscode-with-extensions.override {
        #vscode = (pkgs.vscodium.override {
        /*commandLineArgs =
          "--enable-features=VaapiVideoDecoder,UseOzonePlatform " +
          "--enable-accelerated-video-decode " +
          "--ozone-platform=wayland " +
          "--enable-gpu-rasterization " +
          "--force-dark-mode " +
          "--enable-native-notifications";*/
        #});
   #     vscodeExtensions = with pkgs.vscode-extensions; [
   #        /*sjhuangx.vscode-scheme */ /*runem.lit-plugin */bbenoist.nix ms-vscode-remote.remote-ssh ms-vscode.cpptools ] # jnoortheen.nix-ide mshr-h.veriloghdl ];
   /*        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "vscode-scheme";
      publisher = "sjhuangx";
      version = "0.4.0";
      sha256 = "sha256-BN+C64YQ2hUw5QMiKvC7PHz3II5lEVVy0Shtt6t3ch8=";
    } { 
       name = "lit-plugin";
       publisher = "runem";
       version = "1.2.1";
       sha256 = "sha256-VQNJiuVM1pnPLz2f6RwtxkHiy80OX/lf5xRGYTL8HNk=";
     }];
      })*/
      pkgs.vscode
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
      #pkgs.mumble
      pkgs.wget
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
      pkgs.jetbrains.idea-community
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

      #(pkgs.gradle_6.override {
      #  defaultJava = pkgs.openjdk8;
      #})
      (pkgs.stdenv.mkDerivation {
    pname = "mumble";
    version = "git";

    nativeBuildInputs = with pkgs; [ cmake pkg-config qt5.wrapQtAppsHook qt5.qttools ];
    buildInputs = with pkgs; [ boost protobuf libopus libsndfile speex qt5.qtsvg rnnoise alsa-lib libpulseaudio speechd poco flac libogg avahi-compat celt zeroc-ice grpc ];
    cmakeFlags = [
      #"-Dserver=OFF"
      "-Doverlay-xcompile=OFF"
      "-Dbundled-opus=OFF"
      # "-Dbundled-celt=OFF" # incompatible with some macro
      "-Dbundled-speex=OFF"
      "-Dgrpc=ON"
      "-Ddisplay-install-paths=ON"
      "-DIce_HOME=${pkgs.lib.getDev pkgs.zeroc-ice};${pkgs.lib.getLib pkgs.zeroc-ice}"
      "-DCMAKE_PREFIX_PATH=${pkgs.lib.getDev pkgs.zeroc-ice};${pkgs.lib.getLib pkgs.zeroc-ice}"
      "-DIce_SLICE_DIR=${pkgs.lib.getDev pkgs.zeroc-ice}/share/ice/slice"
      "-DIce_DEBUG=ON"
      #"--log-level=DEBUG"
      #"--debug-find"
    ];
    #NIX_CFLAGS_COMPILE = "-I${self.lib.getDev self.celt}/include/celt";

    src = pkgs.fetchgit {
      url = "https://github.com/mumble-voip/mumble";
      rev = "85a7ce56b6342fe93e5877200751809983dffc01";
      fetchSubmodules = true;
      sha256 = "1j1b5rp76yl7yzl292hxn6h811npwir5wb0b6zn4fa5bn3h5jic4";
    };

    #postInstall = ''
    #  pwd

    #  ls -la
    #  cp plugins/link/link_tester $out/bin
    #'';
  })
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
    package = pkgs.openjdk8;
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
