{ config, lib, pkgs, ... }:
{
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/web-apps/mastodon.nix
  services.mastodon = {
    enable = true;
    configureNginx = true;
    localDomain = "social.pi.example.org";
    redis = {
      createLocally = true;
    };
    database = {
      createLocally = true;
    };
    smtp = {
      fromAddress = "pi.example.org";
      user = "root";
    };
    # TODO elasticsearch

    # TODO FIXME
    # no default user known yet
  };

  # su - mastodon -s /bin/sh
  # mastodon-env tootctl accounts create moritz_hedtke --email=EMAIL
  # mastodon-env tootctl accounts modify moritz_hedtke --confirm
  # mastodon-env tootctl accounts modify moritz_hedtke --role admin

  # openssl s_client -connect video.pi.example.org:https
  # openssl s_client -connect self-signed.badssl.com:https
  # curl https://video.pi.example.org

  # cd pkgs/servers/mastodon/
  # nix build --impure --expr '(builtins.getFlake "nixpkgs").legacyPackages.x86_64-linux.callPackage ./update.nix {}'
  # ./result/bin/update.sh --url https://github.com/mohe2015/mastodon.git --rev 4923aaa5856c822d41516e7c3d88730569853618 --ver 3.3.0 --patches ./resolutions.patch

  # nix --keep-failed build /etc/nixos/nixpkgs#mastodon

  # nix run nixpkgs#nix-prefetch-git -- --url https://github.com/mohe2015/mastodon.git

  /*
  Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] method=GET path=/api/v2/search format=html controller=Api::V2::SearchController action=index status=500 error='NameError: undefined local variable or method `logger' for #<Request:0x0000000007e7a340>' duration=15.79 view=0.00 db=2.30
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2]
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] NameError (undefined local variable or method `logger' for #<Request:0x0000000007e7a340>):
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2]
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/lib/request.rb:30:in `initialize'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/lib/webfinger.rb:87:in `new'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/lib/webfinger.rb:87:in `webfinger_request'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/lib/webfinger.rb:47:in `body_from_webfinger'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/lib/webfinger.rb:37:in `perform'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/helpers/webfinger_helper.rb:5:in `webfinger!'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/resolve_account_service.rb:83:in `process_webfinger!'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/resolve_account_service.rb:31:in `call'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/account_search_service.rb:32:in `exact_match'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/account_search_service.rb:22:in `search_service_results'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/account_search_service.rb:14:in `call'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/search_service.rb:28:in `perform_accounts_search!'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/search_service.rb:18:in `block in call'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/search_service.rb:12:in `tap'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/services/search_service.rb:12:in `call'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/controllers/api/v2/search_controller.rb:19:in `search_results'
Mar 09 20:10:07 pi puma[2071]: [b2b2cc68-7211-4ae6-86fd-423f1e1b18f2] app/controllers/api/v2/search_controller.rb:12:in `index'


*/
}
