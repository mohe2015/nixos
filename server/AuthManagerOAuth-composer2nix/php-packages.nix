{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-ee0a041b1760e6a53d2a39c8c34115adc2af2c79";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/ee0a041b1760e6a53d2a39c8c34115adc2af2c79";
          sha256 = "0wa63kw5fr5jhy2cv1g28qy9rsgwhn902447mzmgz17qjx72lzrb";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
          sha256 = "09ivi77y49bpc2sy3xhvgq22rfh2fhv921mn8402dv0a8bdprf56";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-089edd38f5b8abba6cb01567c2a8aaa47cec4c72";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/089edd38f5b8abba6cb01567c2a8aaa47cec4c72";
          sha256 = "1k29gax82rf82sbw2cbcp4qn3s3096csvmw9848l94q6ryc4j2rb";
        };
      };
    };
    "league/oauth2-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-client-badb01e62383430706433191b82506b6df24ad98";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/badb01e62383430706433191b82506b6df24ad98";
          sha256 = "1j2bmvy39k8wafisxdc0xn58gga5w9jpwp5hqjy51sk1s2ssws8i";
        };
      };
    };
    "paragonie/random_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-random_compat-996434e5492cb4c3edcb9168db6fbb1359ef965a";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/random_compat/zipball/996434e5492cb4c3edcb9168db6fbb1359ef965a";
          sha256 = "0ky7lal59dihf969r1k3pb96ql8zzdc5062jdbg69j6rj0scgkyx";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
          sha256 = "0rkz64vgwb0gfi09klvgay4qnw993l1dc03vyip7d7m2zxi6cy4j";
        };
      };
    };
    "psr/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-client-2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
          sha256 = "0cmkifa3ji1r8kn3y1rwg81rh8g2crvnhbv2am6d688dzsbw967v";
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363";
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
        };
      };
    };
    "ralouphie/getallheaders" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ralouphie-getallheaders-120b605dfeb996808c31b6477290a714d356e822";
        src = fetchurl {
          url = "https://api.github.com/repos/ralouphie/getallheaders/zipball/120b605dfeb996808c31b6477290a714d356e822";
          sha256 = "1bv7ndkkankrqlr2b4kw7qp3fl0dxi6bp26bnim6dnlhavd6a0gg";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-c726b64c1ccfe2896cb7df2e1331c357ad1c8ced";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/c726b64c1ccfe2896cb7df2e1331c357ad1c8ced";
          sha256 = "12gdsgr8wgjyz3zdhg16vkm10kfgqw9wgkr966q5z7i8agvw5asg";
        };
      };
    };
  };
  devPackages = {
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-83e511e247de329283478496f7a1e114c9517506";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/semver/zipball/83e511e247de329283478496f7a1e114c9517506";
          sha256 = "1674fq9h3a523pc4dg98140dvjxjvipd18y6wfsiawhy59kxnapm";
        };
      };
    };
    "composer/spdx-licenses" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-spdx-licenses-a30d487169d799745ca7280bc90fdfa693536901";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/spdx-licenses/zipball/a30d487169d799745ca7280bc90fdfa693536901";
          sha256 = "0dwkbzvynmlp77gkqc6w2f3670h1ag722yvsxvx7ywp8jxblqbz8";
        };
      };
    };
    "mediawiki/mediawiki-codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mediawiki-mediawiki-codesniffer-059db7ef17adf2fd1088c42a05e6736e5c2aab2a";
        src = fetchurl {
          url = "https://api.github.com/repos/wikimedia/mediawiki-tools-codesniffer/zipball/059db7ef17adf2fd1088c42a05e6736e5c2aab2a";
          sha256 = "0dm84ndxzzpkwdwm83wr8n4yd5mjikbcgs25j3v7qbgxi991vsnk";
        };
      };
    };
    "mediawiki/minus-x" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mediawiki-minus-x-74b1fce4acbe6be1f9b4a0775287e09e0e3f6af2";
        src = fetchurl {
          url = "https://api.github.com/repos/wikimedia/mediawiki-tools-minus-x/zipball/74b1fce4acbe6be1f9b4a0775287e09e0e3f6af2";
          sha256 = "168l8hmfc12ns41gdjdcnndsrhb1dvhs1xbc4qrikalv8218pqmj";
        };
      };
    };
    "php-parallel-lint/php-console-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-console-color-b6af326b2088f1ad3b264696c9fd590ec395b49e";
        src = fetchurl {
          url = "https://api.github.com/repos/php-parallel-lint/PHP-Console-Color/zipball/b6af326b2088f1ad3b264696c9fd590ec395b49e";
          sha256 = "030449mkpxs35y8dk336ls3bfdq3zjnxswnk5khlg45z5147cr3k";
        };
      };
    };
    "php-parallel-lint/php-console-highlighter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-console-highlighter-21bf002f077b177f056d8cb455c5ed573adfdbb8";
        src = fetchurl {
          url = "https://api.github.com/repos/php-parallel-lint/PHP-Console-Highlighter/zipball/21bf002f077b177f056d8cb455c5ed573adfdbb8";
          sha256 = "013phmp5n6hp6mvlpbqbrih0zd8h7xc152dpzxxf49b0jczxh8y4";
        };
      };
    };
    "php-parallel-lint/php-parallel-lint" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-parallel-lint-761f3806e30239b5fcd90a0a45d41dc2138de192";
        src = fetchurl {
          url = "https://api.github.com/repos/php-parallel-lint/PHP-Parallel-Lint/zipball/761f3806e30239b5fcd90a0a45d41dc2138de192";
          sha256 = "00z1vcyfghwiv3vv4rw21fr4qwb9sd21dh8v2aj5rzlagcwq2vxl";
        };
      };
    };
    "squizlabs/php_codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "squizlabs-php_codesniffer-f268ca40d54617c6e06757f83f699775c9b3ff2e";
        src = fetchurl {
          url = "https://api.github.com/repos/squizlabs/PHP_CodeSniffer/zipball/f268ca40d54617c6e06757f83f699775c9b3ff2e";
          sha256 = "1836i2in2sryig5qvs8ldj6w5rv0yv7mzgxlrwhl6bn2pghgp2lz";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-9130e1a0fc93cb0faadca4ee917171bd2ca9e5f4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/9130e1a0fc93cb0faadca4ee917171bd2ca9e5f4";
          sha256 = "19b1457cnn8ijbwd4mha6nxhvcsd4kh7dn72klixykj2kvqh0hvg";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-46cd95797e9df938fdd2b03693b5fca5e64b01ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/46cd95797e9df938fdd2b03693b5fca5e64b01ce";
          sha256 = "0z4iiznxxs4r72xs4irqqb6c0wnwpwf0hklwn2imls67haq330zn";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-16880ba9c5ebe3642d1995ab866db29270b36535";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/16880ba9c5ebe3642d1995ab866db29270b36535";
          sha256 = "0pb57756kvdxksqy2nndf8q7c91p2dzhysa52x2rbhba869760fv";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8";
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-9174a3d80210dca8daa7f31fec659150bbeabfc6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/9174a3d80210dca8daa7f31fec659150bbeabfc6";
          sha256 = "17bhba3093di6xgi8f0cnf3cdd7fnbyp9l76d9y33cym6213ayx1";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-fba8933c384d6476ab14fb7b8526e5287ca7e010";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/fba8933c384d6476ab14fb7b8526e5287ca7e010";
          sha256 = "0fc1d60iw8iar2zcvkzwdvx0whkbw8p6ll0cry39nbkklzw85n1h";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-1100343ed1a92e3a38f9ae122fc0eb21602547be";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/1100343ed1a92e3a38f9ae122fc0eb21602547be";
          sha256 = "0kwk2qgwswsmbfp1qx31ahw3lisgyivwhw5dycshr5v2iwwx3rhi";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-d15da7ba4957ffb8f1747218be9e1a121fd298a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/d15da7ba4957ffb8f1747218be9e1a121fd298a1";
          sha256 = "168iq1lp2r5qb5h8j0s17da09iaj2h5hrrdc9rw2p73hq8rvm1w2";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-0cfed595758ec6e0a25591bdc8ca733c1896af32";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/0cfed595758ec6e0a25591bdc8ca733c1896af32";
          sha256 = "03qrsjckg099n06n7dhg35i15wmn5d7zv9rb8kf6gvbbavj1vpla";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "mohe2015-authmanageroauth";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {};
}
