args@{ self, lib, pkgs, nixpkgs, home-manager, config, agenix, release, home-manager-release, ... }:
{
  imports = [
    ../profiles/core
    ../users/moritz
    ../users/tu
    ../users/root
    ../users/anton.nix
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;
    settings = {
      logging_collector = true;
      log_statement = "all";
    };
  };
/*
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
        #enableACME = true;
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
*/
  programs.adb.enable = true;

  services.gnome.gnome-keyring.enable = true;

  services.fwupd = {
    enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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

  /*nix.settings = {
    trusted-public-keys = ["builder-name:RfjHNcvk903x8U/CyOSRfFVsDHCI9uWke1WD9iaIL1Y="];
    trusted-substituters = ["ssh-ng://23.88.56.131" "ssh://23.88.56.131" "ssh://moritz@23.88.56.131"];
  };*/

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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

  services.xserver = {
    screenSection = ''
      Option "TearFree" "true"
      Option "VariableRefresh" "true"
    '';
  };

  /*services.avahi.enable = true;
 services.avahi.nssmdns = true;
 services.avahi.publish = {
    enable = true;
    addresses = true;
    workstation = true;
  };*/
  # STUPID PRINTER https://nixos.wiki/wiki/Printing
  ##services.avahi.nssmdns = false; # Use the settings from below
  # settings from avahi-daemon.nix where mdns is replaced with mdns4
  ##system.nssModules = with pkgs.lib; optional (!config.services.avahi.nssmdns) pkgs.nssmdns;
  ##system.nssDatabases.hosts = with pkgs.lib; optionals (!config.services.avahi.nssmdns) (mkMerge [
  ##  (mkOrder 900 [ "mdns4_minimal [NOTFOUND=return]" ]) # must be before resolve
  ##  (mkOrder 1501 [ "mdns4" ]) # 1501 to ensure it's after dns
  ##]);

  systemd.coredump.enable = true;

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

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/SYSTEM"; fsType = "vfat"; };

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
  hardware.opengl.extraPackages = [ pkgs.mesa pkgs.amdvlk pkgs.vaapiIntel pkgs.libvdpau-va-gl pkgs.vaapiVdpau ];

  # this file has been generated using hdajackretask and overriding "Black Mic, Right Side" to "Not Connected"
  hardware.firmware = [
    (pkgs.runCommandNoCC "firmware-audio-retask" { } ''
      mkdir -p $out/lib/firmware/
      cp ${../hda-jack-retask.fw} $out/lib/firmware/hda-jack-retask.fw
    '')
  ];

  programs.steam.enable = true;

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

  age.identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  age.secrets.eduroam.file = ../secrets/eduroam.age;
  networking.wireless = {
    enable = true;
    environmentFile = config.age.secrets.eduroam.path;
    networks = {
      eduroam = {
        auth=''
        ssid="eduroam"
        key_mgmt=WPA-EAP
        eap=PEAP
        identity="@IDENTITY@"
        password="@PASSWORD@"
        domain_suffix_match="radius.hrz.tu-darmstadt.de"
        anonymous_identity="eduroam@tu-darmstadt.de"
        phase2="auth=MSCHAPV2"
        ca_cert="/etc/ssl/certs/ca-bundle.crt"
        '';
      };
    };
  };

  # Wait for any interface to become available, not for all
  systemd.services."systemd-networkd-wait-online".serviceConfig.ExecStart = [
    "" "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online --any"
  ];

  system.stateVersion = "21.05";
}
