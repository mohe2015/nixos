{
    services.k3s = {
        enable = true;
        role = "agent";
        tokenFile = "/etc/nixos/secrets/k3s";
        serverAddr = "https://192.168.2.128:6443";
    };
    
    # https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#networking
    networking.firewall.allowedTCPPorts = [ 10250 ];
    networking.firewall.allowedUDPPorts = [ 8472 ];
    networking.firewall.enable = false;
}