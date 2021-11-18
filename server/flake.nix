{
  description = "Deployment for my server";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations.nixos-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };

    deploy.nodes.nixos-server = {
      hostname = "94.130.56.136";
    };

    deploy.nodes.nixos-server.profiles.system = {
        sshUser = "root";
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixos-server;
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    devShell = let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in {
      x86_64-linux = pkgs.mkShell {
        nativeBuildInputs = [ deploy-rs.defaultPackage.x86_64-linux nixpkgs.legacyPackages.x86_64-linux.hcloud  ];
      };
    };
  };
}

