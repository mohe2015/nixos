# sudo journalctl -u container@pi.service
# /var/lib/containers/<container name>/var/log/journal and can be read with journalctl --file <filename>.
# sudo journalctl --file /var/lib/containers/pi/var/log/journal/2a103e205fa848549b1ee44593b82a27/system.journal -u acme-cloud.pi.example.org.service


# sudo nixos-rebuild switch
# sudo nixos-container stop pi
# sudo nixos-container start pi

# sudo systemctl restart acme-meet.pi.example.org.service 
# as step-ca seems to start too slow, maybe we can put step-ca into a dependency chain earlier as a hack

{
  description = "Moritz Hedtke's flake";
  # https://blog.ysndr.de/posts/internals/2021-01-01-flake-ification/
  # https://zimbatm.com/NixFlakes/
  # https://github.com/numtide/nix-flakes-installer#github-actions
  # https://www.tweag.io/blog/2020-05-25-flakes/
  # https://github.com/nix-community/home-manager
  # https://nix-community.github.io/home-manager/
  # https://nixos.wiki/wiki/Home_Manager

  inputs =
    {
      nixpkgs.url = "path:/etc/nixos/nixpkgs";
#      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      flake-utils.url = "github:numtide/flake-utils";
      release.url = "github:NixOS/nixpkgs/release-21.05";
      home-manager-release.url = "github:nix-community/home-manager/release-21.05";
      home-manager-release.inputs.nixpkgs.follows = "release";
#      nixpkgs-mozilla.url = "github:mohe2015/nixpkgs-mozilla/flake";
#      nixpkgs-mozilla.inputs.nixpkgs.follows = "nixpkgs";
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "nixpkgs";
    };

  outputs = inputs@{ self, nixpkgs, home-manager, release, home-manager-release, agenix, ... }:
  {
    nixosConfigurations = {
      nixos = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          #overlays = [ nixpkgs-mozilla.overlays.firefox ];
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
#            "steam" "steam-original" "steam-runtime"
             "discord" # run in browser?
             "zoom"
#            "android-studio-canary"
#            "thunderbird-bin"
#            "firefox-release-bin-unwrapped"
#            "firefox-bin"
#            "thunderbird-bin"
#            "firefox-beta-bin" "firefox-beta-bin-unwrapped"
#            "vscode"
#            "minecraft-launcher"
#            "veracrypt"
          ];
        };
      in nixpkgs.lib.nixosSystem {
        inherit pkgs;
        system = "x86_64-linux";
        modules = [
          # https://github.com/nix-community/home-manager#nix-flakes TODO FIXME
          # split up like that maybe we need to pass it the config as parameter
          # https://github.com/nix-community/home-manager/blob/master/flake.nix
          # also contains some useful other bits
          home-manager.nixosModules.home-manager
          (args@{ lib, pkgs, ... }: import ./hosts/nixos.nix (args // { 
            inherit self; 
            inherit nixpkgs; 
            inherit home-manager;
            inherit agenix;
            inherit release;
            inherit home-manager-release;
          }))
          agenix.nixosModules.age
        ];
      };
      nixSD = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          (import ./hosts/nixSD.nix)
          agenix.nixosModules.age
        ];
      };
      nixCrossSD = nixpkgs.lib.nixosSystem {
        modules = [
          (import ./hosts/nixCrossSD.nix)
          agenix.nixosModules.age
        ];
      };
      # sudo nixos-container create test-r --flake /etc/nixos#test-release-container
      test-release-container = release.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager-release.nixosModules.home-manager
          (import ./hosts/nixSD.nix)
          agenix.nixosModules.age
        ];
      };
    };
    packages = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      crossPkgs = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = "aarch64-linux";
      };
    in {
      test = crossPkgs.stdenv.mkDerivation { name = "env"; };
    };
    devShell = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
      crossPkgs = import nixpkgs {
        system = "x86_64-linux";
        crossSystem = "aarch64-linux";
      };
    in {
      test = crossPkgs.mkShell {
        #nativeBuildInputs = [ (crossPkgs.stdenv.mkDerivation { name = "env"; }) ];
      };
    };
  };
}
