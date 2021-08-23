{ self, lib, pkgs, nixpkgs, home-manager, config, agenix, release, home-manager-release, ... }:
{
  ### root password is empty by default ###
  imports = [
    ../profiles/core
    #../profiles/prisma
    ../users/moritz
    ../users/root
    ../profiles/home/earlyoom
    ../profiles/gnome.nix
#    ../profiles/home/peertube
#    ../profiles/k3s-server.nix
    #../profiles/k8s-server.nix #k8s from nixos is garbage
  ];
  
  networking.firewall.enable = false; # kubernetes

  #documentation.nixos.enable = false;

  services.xserver = {
    screenSection = ''
      Option "TearFree" "true"
      Option "VariableRefresh" "true"
    '';
  };

  #programs.adb.enable = true;
  #programs.npm.enable = true;

  #services.avahi.enable = true;
  #services.avahi.nssmdns = true;

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
    192.168.100.11 blog.pi.example.org
    192.168.100.11 mattermost.pi.example.org
    192.168.2.128 core.harbor.domain
    192.168.2.128 keycloak.local
  '';

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    #pkgs.wireguard
    #pkgs.wireguard-tools
    pkgs.kompose
    pkgs.gnome3.adwaita-icon-theme # bugfix for xournalpp https://github.com/xournalpp/xournalpp/issues/999
    agenix.defaultPackage.x86_64-linux
    pkgs.gnome3.gnome-settings-daemon
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
  boot.kernelModules = [ "kvm-amd" "v4l2loopback" "ceph" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

  hardware.cpu.amd.updateMicrocode = true;

  hardware.enableRedistributableFirmware = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.package = pkgs.mesa.drivers;
  hardware.opengl.extraPackages = [ pkgs.mesa pkgs.amdvlk ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.firmware = [
    (pkgs.runCommandNoCC "firmware-audio-retask" { } ''
      mkdir -p $out/lib/firmware/
      cp ${../hda-jack-retask.fw} $out/lib/firmware/hda-jack-retask.fw
    '')
  ];

  #programs.steam.enable = true;

  services.fstrim.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];

  services.xserver.wacom.enable = true;

  services.xserver.libinput.enable = true;

  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  # https://gvolpe.com/blog/gnome3-on-nixos/
/*
  containers.pi = {
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
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "enp1s0";

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
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
  };

  #environment.etc."resolv.conf" = with lib; with pkgs; {
  #  source = writeText "resolv.conf" ''
  #    ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
  #    options edns0
  #  '';
  #};

  security.pki.certificateFiles = [ ../secrets/root_ca.crt ../secrets/intermediate_ca.crt ];

  system.stateVersion = "21.05";

  #boot.binfmt.emulatedSystems = [ "aarch64-linux" ];   
}
