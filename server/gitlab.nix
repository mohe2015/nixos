{ config, ... }:

{
  # tr -dc A-Za-z0-9 < /dev/urandom | head -c 128
  age.secrets.gitlab_root.file = ./secrets/gitlab_root.age;
  age.secrets.gitlab_root.owner = "gitlab";
  age.secrets.gitlab_db.file = ./secrets/gitlab_db.age;
  age.secrets.gitlab_db.owner = "gitlab";
  age.secrets.gitlab_secret.file = ./secrets/gitlab_secret.age;
  age.secrets.gitlab_secret.owner = "gitlab";
  age.secrets.gitlab_otp.file = ./secrets/gitlab_otp.age;
  age.secrets.gitlab_otp.owner = "gitlab";
  age.secrets.gitlab_jws.file = ./secrets/gitlab_jws.age;
  age.secrets.gitlab_jws.owner = "gitlab";

  services.gitlab = {
    enable = true;
    initialRootPasswordFile = config.age.secrets.gitlab_root.path;
    https = true;
    host = "gitlab.selfmade4u.de";
    port = 443;
    secrets = {
      dbFile = config.age.secrets.gitlab_db.path;
      secretFile = config.age.secrets.gitlab_secret.path;
      otpFile = config.age.secrets.gitlab_otp.path;
      jwsFile = config.age.secrets.gitlab_jws.path;
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."gitlab.selfmade4u.de" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://unix:/run/gitlab/gitlab-workhorse.socket";
    };
  };

  networking.firewall.allowedTCPPorts = [ 443 80 ];
}