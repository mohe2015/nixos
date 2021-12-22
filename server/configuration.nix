# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./gitlab.nix
      ./mediawiki.nix
      <agenix/modules/age.nix>
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

  users.mutableUsers = false;

  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.moritz = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # cat ~/.ssh/id_ed25519.pub
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4 moritz@nixos" ];
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4 moritz@nixos" ];
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

  #system.autoUpgrade = {
  #  enable = true;
  #  allowReboot = true;
  #  flake = "/etc/nixos/server";
  #  flags = [ "--update-input" "nixpkgs" "--commit-lock-file" ];
  #};

  nix = {
    useSandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc.automatic = true;
  };

  security.acme.email = "Moritz.Hedtke@t-online.de";
  security.acme.acceptTerms = true;

  /*
    services.matrix-conduit = {
    enable = true;
    settings = {
    global = {
    server_name = "selfmade4u.de";
    allow_encryption = true;
    allow_federation = true;
    #allow_registration = true;
    };
    };
    };
  */

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    /*
      virtualHosts."selfmade4u.de" = {
      enableACME = true;
      forceSSL = true;

      listen = [
      { ssl = true; port = 443; addr = "0.0.0.0"; }
      { ssl = true; port = 443; addr = "[::0]"; }
      { ssl = true; port = 8448; addr = "0.0.0.0"; }
      { ssl = true; port = 8448; addr = "[::0]"; }
      ];

      extraConfig = ''
      merge_slashes off;
      '';

      locations."= /.well-known/matrix/server".extraConfig = ''
      add_header Content-Type application/json;
      return 200 '${builtins.toJSON { "m.server" = "selfmade4u.de:8448"; }}';
      '';

      locations."/_matrix" = {
      proxyPass = "http://[::1]:6167$request_uri";
      extraConfig = ''
      proxy_buffering off;
      '';
      };
      };
    */
  };

  networking.firewall.allowedTCPPorts = [ 443 80 8448 ];

  #services.hydra = {
  #  enable = true;
  #  hydraURL = "http://localhost:3000";
  #  notificationSender = "hydra@localhost";
  #  buildMachinesFiles = [];
  #  useSubstitutes = false;
  #};

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
