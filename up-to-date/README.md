https://github.com/NixOS/nixpkgs/blob/master/maintainers/scripts/find-tarballs.nix



NIX_PATH=nixpkgs=channel:nixos-unstable nix-instantiate --eval --json --strict ./find-tarballs.nix   --arg expr 'import <nixpkgs/maintainers/scripts/all-tarballs.nix>' | jq -r '.[][]'

