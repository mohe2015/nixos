let
  moritz_laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKpm6jXKndgHfeANK/Dipr2f5x75EDY17/NfUieutEJ4 moritz@nixos";
  users = [ moritz_laptop ];

  selfmade4u_de = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeKefwVeK6oDm78+8JRl1Kk3AEXG52lgcqNpQWt+eBy root@nixos";
  systems = [ selfmade4u_de ];
in
{
  "gitlab_root.age".publicKeys = [ moritz_laptop selfmade4u_de ];
  "gitlab_db.age".publicKeys = [ moritz_laptop selfmade4u_de ];
  "gitlab_secret.age".publicKeys = [ moritz_laptop selfmade4u_de ];
  "gitlab_otp.age".publicKeys = [ moritz_laptop selfmade4u_de ];
  "gitlab_jws.age".publicKeys = [ moritz_laptop selfmade4u_de ];
  "mediawiki_admin.age".publicKeys = [ moritz_laptop selfmade4u_de ];
  "mediawiki_oauth.age".publicKeys = [ moritz_laptop selfmade4u_de ];
}
