# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # hetzner doesnt support efi only but this would probably allow automatic rollback
  #boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos-server"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.useNetworkd = true;

  systemd.network.enable = true;
  systemd.network.networks = {
    "40-wired" = {
      enable = true;
      name = "en*";
      DHCP = "yes";
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.moritz = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # sudo cat /root/.ssh/id_rsa.pub
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkur1jL+EAQ+i48svt0iERUYNAA6tlR3TeVXq2+IXc4WoerwXzpUwuagB5ynNyTdk+nmAzLZ4kP/kbkqI3DkZhcHL9k2E0ywdsxsHezCEeDu7h5ZwsZr9gkGPjJtceRtk5bE/JQrrBvZWhn7N3bghNj8skuaox1qtiU2KpEW8mlg6yxYMJIEdPXnLWRep8kCj/HCZwJ9wzpYs1ZdNsNIom2/eXGaK0b/1wvypTsC991oBzXtdEICR7Vyd/tlTQ0+roN2PSPSqQgq3RQx/87fz2rlfSu3bXAG0gZ5/aPPjRSqs4B5v0duwapNl6gDI2kwzwd4ORIDQgZwm979z+FmlXrJWnuvyvR/caih/pbRFu4DHWPRhJERTaHvCUBC12BJI5PkyJEvgWcFxdOo6EFPCvYvBRP2TweEWr0da5LA1sseeu+HVjTtfP9EAAqxOT6vR98c7gIT5YkW7Bw/xgdWxzVLdcSMooquGB4WyI2J8HneakVVxlPGhYgrS1GwjdO+zZMY75Jqo3qnK11M/gYX+0FHraDKf0tT3Ygk8FgRVmHG/t3U6T7zk+mHYf1+oeoFHC88gob7DJL3fQCf+288dzqqxqG3esJlwj3/hwQThLu6QipyyQ86jC/rz+ann7LnEGRf9Zg8ykVDGj/POhxWHD1tw0mUTtFQh2mdyKGlNABQ== root@nixos" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4 moritz@nixos" ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDkur1jL+EAQ+i48svt0iERUYNAA6tlR3TeVXq2+IXc4WoerwXzpUwuagB5ynNyTdk+nmAzLZ4kP/kbkqI3DkZhcHL9k2E0ywdsxsHezCEeDu7h5ZwsZr9gkGPjJtceRtk5bE/JQrrBvZWhn7N3bghNj8skuaox1qtiU2KpEW8mlg6yxYMJIEdPXnLWRep8kCj/HCZwJ9wzpYs1ZdNsNIom2/eXGaK0b/1wvypTsC991oBzXtdEICR7Vyd/tlTQ0+roN2PSPSqQgq3RQx/87fz2rlfSu3bXAG0gZ5/aPPjRSqs4B5v0duwapNl6gDI2kwzwd4ORIDQgZwm979z+FmlXrJWnuvyvR/caih/pbRFu4DHWPRhJERTaHvCUBC12BJI5PkyJEvgWcFxdOo6EFPCvYvBRP2TweEWr0da5LA1sseeu+HVjTtfP9EAAqxOT6vR98c7gIT5YkW7Bw/xgdWxzVLdcSMooquGB4WyI2J8HneakVVxlPGhYgrS1GwjdO+zZMY75Jqo3qnK11M/gYX+0FHraDKf0tT3Ygk8FgRVmHG/t3U6T7zk+mHYf1+oeoFHC88gob7DJL3fQCf+288dzqqxqG3esJlwj3/hwQThLu6QipyyQ86jC/rz+ann7LnEGRf9Zg8ykVDGj/POhxWHD1tw0mUTtFQh2mdyKGlNABQ== root@nixos" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4 moritz@nixos" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  nix.gc.automatic = true;

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = false;
  };

#  nix.extraOptions = ''
#    secret-key-files = /root/cache-priv-key.pem
#  '';

  # autodetected
  #fileSystems."/nix" = {
  #  device = "/dev/disk/by-id/scsi-0HC_Volume_14477825";
  #  fsType = "ext4";
  #  options = [ "discard" "nofail" "defaults" ];
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}
