TODO write a second script that just installs nix on debian because this should also be enough for remote building


./hetzner.sh -n nixos-builder -t ccx32

# https://nixos.org/manual/nixos/stable/#sec-building-parts

https://nixos.wiki/wiki/Distributed_build

sudo ssh-keygen -R 23.88.58.221
sudo ssh root@23.88.58.221 nix-store --version
sudo ssh moritz@23.88.58.221 nix-store --version
ssh root@23.88.58.221 nix sign-paths --all -k /root/cache-priv-key.pem


https://github.com/NixOS/nix/issues/2789
https://github.com/NixOS/hydra/issues/584


ssh root@23.88.58.221 nix-store --version
ssh moritz@23.88.58.221 nix-store --version
nix store ping --store ssh://root@23.88.58.221
nix store ping --store ssh://moritz@23.88.58.221
ssh root@23.88.58.221 nix sign-paths --all -k /root/cache-priv-key.pem
ssh root@23.88.58.221 cat /root/cache-pub-key.pem # add in system config

sudo nix build -j0 .#nixosConfigurations.nixos.config.system.build.toplevel
sudo nix build .#nixosConfigurations.nixos.config.system.build.toplevel


 nix show-derivation /nix/store/hash-foo.drv 


how to recover from removed build machines

sudo rm /etc/nix/machines
sudo nix build --option substitute false .#nixosConfigurations.nixos.config.system.build.toplevel
sudo nix build --substituters 'https://cache.nixos.org' .#nixosConfigurations.nixos.config.system.build.toplevel







nix-shell -p git
git clone https://github.com/mohe2015/nixos.git
cd nixos
rmdir nixpkgs
git clone --branch libinput-mouse-debounce --depth 1 https://github.com/mohe2015/nixpkgs.git

#       nixpkgs.url = "github:mohe2015/nixpkgs/libinput-mouse-debounce";
nix-shell -p nixFlakes
nix --experimental-features "nix-command flakes" flake update

nix --experimental-features "nix-command flakes" build .#nixosConfigurations.nixos.config.system.build.toplevel

nix-build -A system compat/nixos/ --argstr hostname nixos
