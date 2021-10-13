{ self, lib, pkgs, nixpkgs, home-manager, config, agenix, release, home-manager-release, ... }:
{
  ### root password is empty by default ###
  imports = [
    #../cachix.nix
    ../profiles/core
   # ../profiles/prisma
    ../users/moritz
    ../users/tu
    ../users/root
    ../profiles/home/earlyoom
    ../profiles/databases
    #../profiles/gnome.nix
    ../profiles/home/wordpress
#    ../profiles/home/peertube
#    ../profiles/k3s-server.nix
    #../profiles/k8s-server.nix #k8s from nixos is garbage
  ];
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

  programs.java.enable = true;

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

  ##services.avahi.enable = true;
  #services.avahi.nssmdns = true;
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
    192.168.100.11 blog.pi.example.org
    192.168.100.11 mattermost.pi.example.org
    192.168.2.128 core.harbor.domain
    192.168.2.128 keycloak.local
  '';

  virtualisation.docker.enable = true;

  environment.systemPackages = [
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
  boot.kernelModules = [ "kvm-amd" /*"v4l2loopback" */];
  #boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

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

  #services.fstrim.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.videoDrivers = [ "amdgpu" "modesetting" ];

  services.xserver.wacom.enable = true;

  services.xserver.libinput.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];   
}
