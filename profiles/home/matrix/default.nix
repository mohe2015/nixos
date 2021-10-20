{ config, lib, pkgs, ... }:
{
  # TODO https://nixos.wiki/wiki/Matrix
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/misc/matrix-synapse.nix
  services.matrix-synapse = {
    enable = true;
    database_type = "psycopg2"; # postgresql
    #tls_certificate_path = "${config.security.acme.certs."matrix.pi.example.org".directory}/fullchain.pem";
    #tls_private_key_path = "${config.security.acme.certs."matrix.pi.example.org".directory}/key.pem";
    server_name = "matrix.pi.example.org";
    public_baseurl = "https://matrix.pi.example.org/";
    listeners = [
      {
        port = 8086; # TODO FIXME centralized module for storing these to prevent duplicates
        tls = false;
        x_forwarded = true; # TODO FIXME do this for the other modules too
        resources = [
          {
            names = [ "client" "federation" ];
            compress = false;
          }
        ];
      }
    ];
    enable_registration = true; # TODO FIXME
    registration_shared_secret = "elephant"; # TODO FIXME security
    # macaroon_secret_key TODO FIXME
    # enable_metrics
  };

  # nix run nixpkgs#element-desktop
  /*
    initialScript = pkgs.writeText "synapse-init.sql" ''
    DO $$
    BEGIN
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    EXCEPTION WHEN DUPLICATE_OBJECT THEN
    RAISE NOTICE 'not creating role matrix-synapse -- it already exists';
    END
    $$;

    CREATE EXTENSION IF NOT EXISTS dblink;

    DO $$
    BEGIN
    PERFORM dblink_exec(''', 'CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
    TEMPLATE template0
    LC_COLLATE = "C"
    LC_CTYPE = "C";');
    EXCEPTION WHEN duplicate_database THEN RAISE NOTICE '%, skipping', SQLERRM USING ERRCODE = SQLSTATE;
    END
    $$;
    '';
  */
  /*services.postgresql = {
    enable = true;

    ensureDatabases = [ "matrix-synapse" ]; # needs some custom options that can't be set
    ensureUsers = [
    {
    name = "matrix-synapse";
    ensurePermissions = {
    "DATABASE \"matrix-synapse\"" = "ALL PRIVILEGES";
    };
    }
    ];
    };*/

  systemd.services.matrix-synapse = {
    requires = [ "postgresql.service" "acme-matrix.pi.example.org" ];
    after = [ "postgresql.service" "acme-matrix.pi.example.org" ];
  };

  security.acme.certs = {
    "matrix.pi.example.org" = {
      #group = "matrix-synapse";
    };
  };

  services.nginx = {
    virtualHosts = {
      "nginx-matrix.pi.example.org" = {
        serverName = "matrix.pi.example.org";
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost:8086";
        };
      };
    };
  };
}
