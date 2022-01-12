{
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = "/etc/nixos/secrets/k3s";
    extraFlags = "--cluster-init";
  };
  # https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/

  # https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#networking
  networking.firewall.allowedTCPPorts = [ 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];
  networking.firewall.enable = false;

  # https://rancher.com/docs/k3s/latest/en/cluster-access/#accessing-the-cluster-from-outside-with-kubectl
  # sudo k3s kubectl cluster-info
  # https://rancher.com/docs/k3s/latest/en/installation/kube-dashboard/
}
