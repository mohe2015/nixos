args@{ self, lib, pkgs, nixpkgs, home-manager, config, agenix, release, home-manager-release, ... }:
{
  ### root password is empty by default ###
  imports = [
    #../cachix.nix
    ../profiles/core
    # ../profiles/prisma
    ../users/moritz
    ../users/tu
    ../users/root
    ../users/anton.nix
    ../profiles/home/earlyoom
    #../profiles/databases
    #../profiles/mediawiki.nix
    #../profiles/gnome.nix
    (import ../profiles/home/wordpress (args))
    #    ../profiles/home/peertube
    #    ../profiles/k3s-server.nix
    #../profiles/k8s-server.nix #k8s from nixos is garbage
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "Moritz.Hedtke@t-online.de";

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
  };

  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "localhost" = {
        #http3 = true;
        http2 = true;
        default = true;
        onlySSL = true;
        enableACME = true;
        extraConfig = ''

client_max_body_size 15k;

location = /favicon.ico {
    expires max;
    root   /opt/projektwahl-lit/dist/;
    try_files /favicon.ico =404;
  }

  location / {
    expires epoch;
    root   /opt/projektwahl-lit/dist/;
    try_files /index.html =404;
  }

  location /dist {
    expires max;  
    root   /opt/projektwahl-lit/;
    try_files $uri =404;
  }

  location /node_modules {
    expires epoch;
    root   /opt/projektwahl-lit/;
    try_files $uri =404;
  }

  location /src {
    expires epoch;
    root   /opt/projektwahl-lit/;
    try_files $uri =404;
  }

  location /api {
    proxy_pass https://localhost:8443;
  }

        '';
      };
    };
  };

  #services.guix.enable = true;

  users = {
    extraUsers = lib.fold (a: b: a // b) { } (builtins.map
      (i: {
        "guixbuilder${i}" = {
          group = "guixbuild";
          extraGroups = [ "guixbuild" ];
          home = "/var/empty";
          shell = pkgs.shadow;
          description = "Guix build user ${i}";
          isSystemUser = true;
        };
      }) [ "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" ]);
    extraGroups.guixbuild = { name = "guixbuild"; };
  };

  # /root/.config/guix/current/lib/systemd/system/guix-daemon.service
  systemd.services.guix-daemon = {
    enable = true;
    description = "Build daemon for GNU Guix";
    serviceConfig = {
      ExecStart = "/var/guix/profiles/per-user/root/current-guix/bin/guix-daemon --build-users-group=guixbuild";
      Environment = [ "GUIX_LOCPATH=/var/guix/profiles/per-user/root/guix-profile/lib/locale" "LC_ALL=en_US.utf8" ];
      RemainAfterExit = "yes";

      # See <https://lists.gnu.org/archive/html/guix-devel/2016-04/msg00608.html>.
      # Some package builds (for example, go@1.8.1) may require even more than
      # 1024 tasks.
      TasksMax = "8192";
    };
    wantedBy = [ "multi-user.target" ];
  };

  /*systemd.services.step-ca = {
    serviceConfig = {
      ReadOnlyPaths = "/var/data/step-ca";
    };
  };*/



  /*services.step-ca = {
    enable = true;
    address = "0.0.0.0";
    port = 8443;
    openFirewall = true;
    intermediatePasswordFile = "/var/data/step-ca/secrets/password";
    settings = {
      dnsNames = [ "caserver" ];
      root = "/var/data/step-ca/certs/root_ca.crt";
      crt = "/var/data/step-ca/certs/intermediate_ca.crt";
      key = "/var/data/step-ca/secrets/intermediate_ca.key";
      db = {
        type = "badger";
        dataSource = "/var/lib/step-ca/db";
      };
      authority = {
        provisioners = [
          {
            type = "ACME";
            name = "acme";
          }
        ];
      };
    };
  };*/

  programs.adb.enable = true;

  services.gnome.gnome-keyring.enable = true;

  #programs.chromium.enable = true;

  services.fwupd = {
    enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  #services.fprintd.enable = true;
  #security.pam.services.login.fprintAuth = true;
  #security.pam.services.xscreensaver.fprintAuth = true;

  nix.daemonIOSchedPriority = 7;
  /*
    nix.buildMachines = [ {
    # The path to the SSH private key with which to authenticate on the build machine. The private key must not have a passphrase. If null, the building user (root on NixOS machines) must have an appropriate ssh configuration to log in non-interactively. Note that for security reasons, this path must point to a file in the local filesystem, *not* to the nix store. 
    sshUser = "root";
    hostName = "23.88.58.221";
    system = "x86_64-linux";
    # if the builder supports building for multiple architectures, 
    # replace the previous line by, e.g.,
    # systems = ["x86_64-linux" "aarch64-linux"];
    maxJobs = 16;
    speedFactor = 4;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    mandatoryFeatures = [ ];
    }] ;
    nix.distributedBuilds = true;
    nix.extraOptions = ''
    #builders-use-substitutes = true
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= builder-name:qGtArP3UaBSwjDmdbUIQM+Of8ARrAfC2AOp+fUXRNLI=
    substituters = ssh://root@23.88.58.221
    '';
  */
  #networking.firewall.enable = false; # kubernetes

  #  nix.useSandbox = lib.mkForce false;

  #boot.tmpOnTmpfs = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
   # media-session.enable = true;
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        #xdg-desktop-portal-wlr
        #xdg-desktop-portal-gtk
        xdg-desktop-portal-kde
      ];
      #gtkUsePortal = true;
    };
  };

  fonts.fonts = with pkgs; [
    font-awesome
  ];

  security.pam.services.swaylock = { };


  programs.zsh.enable = true;

  #services.printing.enable = true;
  #services.printing.drivers = [ pkgs.gutenprint ];

  #hardware.sane.enable = true;

  #documentation.nixos.enable = false;

  services.xserver = {
    screenSection = ''
      Option "TearFree" "true"
      Option "VariableRefresh" "true"
    '';
  };

  #programs.adb.enable = true;
  #programs.npm.enable = true;

  services.avahi.enable = true;
 services.avahi.nssmdns = true;
 services.avahi.publish = {
    enable = true;
    addresses = true;
    workstation = true;
  };
  # STUPID PRINTER https://nixos.wiki/wiki/Printing
  ##services.avahi.nssmdns = false; # Use the settings from below
  # settings from avahi-daemon.nix where mdns is replaced with mdns4
  ##system.nssModules = with pkgs.lib; optional (!config.services.avahi.nssmdns) pkgs.nssmdns;
  ##system.nssDatabases.hosts = with pkgs.lib; optionals (!config.services.avahi.nssmdns) (mkMerge [
  ##  (mkOrder 900 [ "mdns4_minimal [NOTFOUND=return]" ]) # must be before resolve
  ##  (mkOrder 1501 [ "mdns4" ]) # 1501 to ensure it's after dns
  ##]);

  systemd.coredump.enable = true;

  #  services.gitlab-runner = {
  #    enable = true;
  #    concurrent = 10;
  #    services = {
  #      default = {
  #        registrationConfigFile = "/etc/nixos/secrets/gitlab-ci";
  #        dockerImage = "scratch";
  #      };
  #    };
  #  };

  networking.extraHosts =
    ''
      127.0.0.1 peertube.localhost
      192.168.100.11 totallynotlocalhost.de
      127.0.0.1 blog.pi.example.org
      192.168.100.11 mattermost.pi.example.org
      192.168.2.128 core.harbor.domain
      192.168.2.128 keycloak.local
    '';

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
    #pkgs.wireguard
    #pkgs.wireguard-tools
    #pkgs.kompose
    pkgs.gnome3.adwaita-icon-theme # bugfix for xournalpp https://github.com/xournalpp/xournalpp/issues/999
    agenix.defaultPackage.x86_64-linux
    #pkgs.gnome3.gnome-settings-daemon
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.configurationLimit = 5;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  #virtualisation.libvirtd.enable = true;

  #programs.wireshark.enable = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/SYSTEM"; fsType = "vfat"; };

  swapDevices = [
    {
      device = "/swapfile";
      priority = 0;
      size = 16384;
    }
  ];

  services.openssh.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableRedistributableFirmware = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.package = pkgs.mesa.drivers;
  # --enable-features=VaapiVideoDecoder
  hardware.opengl.extraPackages = [ pkgs.mesa pkgs.amdvlk pkgs.vaapiIntel pkgs.libvdpau-va-gl pkgs.vaapiVdpau ];

  # commented out for pulseaudio
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # easiest solution: hdajackretask
  /*
    nix shell nixpkgs#tree nixpkgs#psmisc nixpkgs#alsaTools
    hdajackretask

    alsa-info

    alsactl
    name 'Capture Switch'



    # my device doesnt seem to suppport dynamic reconfig
    # it does: The codec is being used, can't reconfigure.
    # just pulseaudio probably needs to be stopped

    pacmd list-sources


    [    3.435049] snd_hda_codec_realtek hdaudioC1D0: autoconfig for ALC236: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
    [    3.435147] snd_hda_codec_realtek hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
    [    3.435148] snd_hda_codec_realtek hdaudioC1D0:    hp_outs=1 (0x21/0x0/0x0/0x0/0x0)
    [    3.435149] snd_hda_codec_realtek hdaudioC1D0:    mono: mono_out=0x0
    [    3.435150] snd_hda_codec_realtek hdaudioC1D0:    inputs:
    [    3.435151] snd_hda_codec_realtek hdaudioC1D0:      Mic=0x19
    [    3.435152] snd_hda_codec_realtek hdaudioC1D0:      Internal Mic=0x12


    snd_hda_codec_realtek


    amixer --card 1 contents



    # I think my model is actually correct, just the driver does not 100% what I want
    #boot.extraModprobeConfig = ''
    #options snd-hda-intel model=YOUR_MODEL 
    #'';


    arecord --device=hw:1,0 -f S32_LE -d 10 -r 44100 -c 2 /tmp/test-mic.wav
    aplay --device=hw:1,0 /tmp/test-mic.wav

    # https://www.kernel.org/doc/html/latest/sound/hd-audio/notes.html#hd-audio-reconfiguration
    # echo "auto_mic = false" | sudo tee /sys/class/sound/hwC1D0/hints
    # echo "hp_mic_detect = false" | sudo tee /sys/class/sound/hwC1D0/hints
    # echo "add_hp_mic = true" | sudo tee /sys/class/sound/hwC1D0/hints
    # echo 1 | tee /sys/class/sound/hwC1D0/reconfig
    # TODO FIXME test this again after reboot and disabling pulseaudio

    # line_in_auto_switch
    # hp_mic_detect = false
    # add_hp_mic

    # pacmd set-source-port 2 analog-input-internal-mic


    # https://nixos.wiki/wiki/ALSA contains really useful info at the end

    # systemctl --user mask pulseaudio.socket && systemctl --user stop pulseaudio
    # sudo rmmod snd-hda-intel

    # TODO dmesg | grep hda

    # https://www.kernel.org/doc/html/latest/sound/hd-audio/models.html

    # add_hp_mic hp_mic_detect auto_mic

    # pacmd list-sources > headset
    # pacmd list-sources > speaker
    # https://unix.stackexchange.com/questions/348823/how-to-force-pulseaudio-ports-to-be-available
    # pacmd list-cards
    # shows profiles usually these are at fault
    # pacmd set-card-profile 1 output:analog-stereo+input:analog-stereo
    # in my case another profile does not help
    # https://www.kernel.org/doc/html/latest/sound/hd-audio/notes.html#hd-audio-reconfiguration

    # options snd-hda-intel model=hp-dv5
    # /etc/modprobe.d/modprobe.conf

    # https://help.ubuntu.com/community/HdaIntelSoundHowto
    # cat /proc/asound/card* /codec* | grep Codec
    # Codec: Realtek ALC236
    # https://bbs.archlinux.org/viewtopic.php?id=254354

    # https://github.com/torvalds/linux/blob/master/Documentation/sound/hd-audio/models.rst

    # nix shell nixpkgs#alsaTools: hdajackretask
    # nix run nixpkgs#pavucontrol
    # https://askubuntu.com/questions/1267949/how-do-i-automatically-switch-pulseaudio-input-to-headset-upon-connection

  
  */
  # this file has been generated using hdajackretask and overriding "Black Mic, Right Side" to "Not Connected"
  hardware.firmware = [
    (pkgs.runCommandNoCC "firmware-audio-retask" { } ''
      mkdir -p $out/lib/firmware/
      cp ${../hda-jack-retask.fw} $out/lib/firmware/hda-jack-retask.fw
    '')
  ];


  programs.steam.enable = true;

  #services.fstrim.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];

  services.xserver.wacom.enable = true;

  services.xserver.libinput.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "plasma";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.runUsingSystemd = true;
  # https://gvolpe.com/blog/gnome3-on-nixos/

  /* containers.pi = {
    nixpkgs = release;
    config = {
    imports = [
    home-manager-release.nixosModules.home-manager
    (import ./nixSD.nix)
    agenix.nixosModules.age
    ];
    };
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    autoStart = true;
    timeoutStartSec = "2min";
    };
  */
  /*
    containers.pi = {
    config = {
    imports = [
    home-manager.nixosModules.home-manager
    (import ./nixSD.nix)
    agenix.nixosModules.age
    ];
    };
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    autoStart = true;
    timeoutStartSec = "2min";
    };
  */
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "enp1s0";

  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network.networks = let
    networkConfig = {
      DHCP = "yes";
      #DNSSEC = "yes";
      #DNSOverTLS = "yes";
      #DNS = [ "1.1.1.1" "1.0.0.1" ];
    };
  in {
    # Config for all useful interfaces
    "40-wired" = {
      enable = true;
      name = "en*";
      inherit networkConfig;
      dhcpV4Config.RouteMetric = 1024; # Better be explicit
    };
    "40-wireless" = {
      enable = true;
      name = "wl*";
      inherit networkConfig;
      dhcpV4Config.RouteMetric = 2048; # Prefer wired
    };
  };

  # Wait for any interface to become available, not for all
  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  #networking = {
  #  useDHCP = false;
    #networkmanager.enable = true;
    #interfaces.enp1s0 = {
    #  useDHCP = false;
    #  ipv4.addresses = [{
    #    address = "192.168.2.129";
    #    prefixLength = 24;
    #  }];
    #};
    #defaultGateway = "192.168.2.1";
    #search = [""];
    #nameservers = [ "8.8.8.8" "192.168.2.1" ];
  #};

  #environment.etc."resolv.conf" = with lib; with pkgs; {
  #  source = writeText "resolv.conf" ''
  #    ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
  #    options edns0
  #  '';
  #};

  #security.pki.certificateFiles = [ ../secrets/root_ca.crt ../secrets/intermediate_ca.crt ];

  system.stateVersion = "21.05";

  #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
