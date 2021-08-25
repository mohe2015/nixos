https://github.com/ryantm/nixpkgs-update

nix-build maintainers/scripts/build.nix --argstr maintainer <name>

nix-env -f compat/nixos --arg configuration hosts/nixSD.nix -iA config.system.build.toplevel --show-trace


nix-env -f '<nixpkgs/nixos>' --arg configuration '{ fileSystems."/".device = "/tmp"; boot.loader.grub.devices = ["nodev"]; security.acme.acceptTerms = true; security.acme.email = "test@example.org"; services.jitsi-meet.enable = true; services.jitsi-meet.hostName = "localhost"; }' -iA config.system.build.toplevel


nix build .#nixosConfigurations.nixos.config.system.build.toplevel

nix build .#nixosConfigurations.nixSD.config.system.build.vm

nix build .#nixosConfigurations.nixSD.config.system.build.sdImage


nix run github:ryantm/agenix -- -e pi-smallstep-intermediate-password.age

# ssh-add ~/.ssh/id_ed25519
# nix run github:ryantm/agenix -- -r -i /home/moritz/.ssh/id_ed25519

sudo nix run github:ryantm/agenix -- -r -i /etc/ssh/ssh_host_ed25519_key

https://github.com/NixOS/nix/issues/1118


how to recover from removed build machines

rm /etc/nix/machines
nix build --option substitute false .#nixosConfigurations.nixos.config.system.build.toplevel
