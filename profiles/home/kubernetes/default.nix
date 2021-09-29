{ config, lib, pkgs, ... }:
{
    # https://github.com/NixOS/nixpkgs/tree/master/nixos/modules/services/cluster/kubernetes
  services.kubernetes = {
    roles = ["master"];
    masterAddress = "kubernetes-primary.pi.example.org";
  };
}