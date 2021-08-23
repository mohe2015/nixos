# PRs I'm interested in:
# mattermost:
# https://github.com/NixOS/nixpkgs/pull/126629
# https://github.com/NixOS/nixpkgs/pull/119200
# https://github.com/NixOS/nixpkgs/pull/117046


# sudo nixos-container create pi --flake /etc/nixos#nixSD
# in bind service: ip $(nixos-container show-ip pi)
# sudo nixos-container start pi

# sudo chattr -i /var/lib/containers/pi/var/empty
# sudo rm -Rf /var/lib/containers/pi
{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    
    # passwd is nixos by default
    ../users/nixos
    # passwd is empty by default
    ../users/root
    #"${modulesPath}/profiles/minimal.nix"
    #"${modulesPath}/profiles/headless.nix"
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../profiles/core
    ../profiles/home/bind
    ../profiles/home/ca
    ##../profiles/home/earlyoom
    ##../profiles/home/fail2ban
    ##../profiles/home/gitea
    #../profiles/home/grafana
    #../profiles/home/graphite
    ##../profiles/home/grocy
    ##../profiles/home/jitsi
    #../profiles/home/kubernetes
    ##../profiles/home/matomo
    ##../profiles/home/matrix
    ##../profiles/home/mediawiki
    #../profiles/home/minecraft-server
    ##../profiles/home/moodle
    ##../profiles/home/mumble
    ##../profiles/home/netdata
    ##../profiles/home/nextcloud
    #../profiles/home/prometheus
    #../profiles/home/searx # currently broken
    ##../profiles/home/tor
    ../profiles/home/wordpress
    #../profiles/home/peertube
    ##../profiles/home/mastodon
    ##../profiles/home/cryptpad
    #../profiles/home/mattermost
    #../profiles/k3s-agent.nix
  ];

  networking.hostName = "nixSD";
  
  #boot.loader.grub.enable = false;
  #boot.loader.raspberryPi = {
  #  enable = true;
  #  version = 4;
  #  uboot = {
  #    enable = true;
  #    configurationLimit = 5;
  #  };
  #};

  # TODO FIXME find out why adding, removing and readding this line needs to rebuild :(
  #boot.kernelPackages = pkgs.linuxPackages_rpi4; # why do I need to add this explicitly with 6e591f2be9121edb21f4111438b11567bb48e138261e3d55263182384cc256ce3c7c3559ed22717c4b8d186ad302627e6677b02065e4af60b42c459c708429d6

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = lib.mkForce [ "ext4" "vfat" ];

  sdImage.compressImage = false;

  ##boot.loader.grub.device = "nodev";
  ##fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "ext4"; };
  
  #boot.initrd.availableKernelModules = lib.mkForce [
    # Allows early (earlier) modesetting for the Raspberry Pi
  #  "vc4" "bcm2835_dma" "i2c_bcm2835"
    # Allows early (earlier) modesetting for Allwinner SoCs
    # "sun4i_drm" "sun8i_drm_hdmi" "sun8i_mixer"
  #];

  # TODO send a fix or improve documentation
  # environment.noXlibs = false; # set in minimal profile. without this it breaks jitsi as gtk3 fails to compile without xlibs

  #environment.systemPackages = [ pkgs.htop pkgs.git pkgs.dnsutils ];

  # FIXME storing the secrets in the git repo that contains the configuration puts them into the nix store. 

  # FIXME https://www.heise.de/ct/artikel/Router-Kaskaden-1825801.html
  # TODO just buy a Fritzbox and replace current router (check for Telekom TV support)
  # some routers have a builtin vpn

  # another possibility would be to run all the below services in lxc with virtual networking and additional systemd hardening and only allow these interfaces to talk to the router and not to other devices in the network. This would rely on the security of NixOS and Linux but it shouldn't be too bad.

  # TODO check which database is officially recommended, choose postgresql otherwise
  # TODO some backup solution https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/services/backup

  # TODO better ssh security
  # TODO better firewall security
  # TODO apparmor / selinux
  # TODO auditd
  # TODO hardened kernel?
  # TODO filesystem quotas
  # TODO collabora online https://github.com/NixOS/nixpkgs/pull/77383

  # TODO lock-kernel-modules
  # TODO systemd-confinement
  # TODO encrypted fs?
  # TODO continouus integration?
  # TODO minetest-server # proabably not now
  # TODO logging
  # TODO mail :(
  # TODO more minimal git like gitit, gitolite or gitweb
  # TODO nix-serve
  # TODO vpn
  # TODO torrent service (alternative to something like ipfs)
  # TODO pastebin like (cryptpad, ?) https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/cryptpad.nix
  # TODO keycloak (sso?)

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.httpd.adminAddr = "root@example.org";

  #services.nginx = {
  #  enable = true;
  #  recommendedTlsSettings = true;
  #  recommendedOptimisation = true;
  #  recommendedGzipSettings = true;
  #  recommendedProxySettings = true;
  #};

  #services.httpd.group = "nginx"; # allow ACME for both

  #services.mysql.package = pkgs.mariadb;

  # TODO bigbluebutton https://github.com/helsinki-systems/bbb4nix seems to be ugly to use

  # TODO etherpad, ethercalc

  # TODO peertube https://github.com/NixOS/nixpkgs/pull/106492

  # TODO mastodon? https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/mastodon.nix

  # TODO some forum software? (discourse)

  # TODO syncthing or git-annex

  # TODO mapping service? like OSM https://github.com/openstreetmap

  # overleaf latex editor

  # TODO bitwarden server

  # ticket system (I used for school)

  # TODO some socks proxy?

  # TODO searx

  # TODO "read the docs" tool

  # TODO url shortener

  # TODO irc logger server (for the nixos irc)

  # TODO weblate

  # https://github.com/awesome-selfhosted/awesome-selfhosted#knowledge-management-tools

  # https://github.com/awesome-selfhosted/awesome-selfhosted

  # https://git.immae.eu/cgit/perso/Immae/Config/Nix.git/

#  hardware.enableRedistributableFirmware = lib.mkDefault true;
#  hardware.pulseaudio.enable = lib.mkDefault true;
#  sound.enable = lib.mkDefault true;

#  documentation.enable = false;
#  networking.wireless.enable = true;

  system.stateVersion = "21.11";
}
