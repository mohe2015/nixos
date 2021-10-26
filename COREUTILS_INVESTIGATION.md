./hetzner-nix-on-deb.sh -n nix-builder -t ccx52

#sudo nano /etc/systemd/logind.conf
#RuntimeDirectorySize=90%
#sudo reboot

tmux new

git clone --branch staging-what --depth 1 https://github.com/mohe2015/nixpkgs.git
cd nixpkgs
git remote add upstream https://github.com/NixOS/nixpkgs.git
git fetch --depth 1 upstream staging-next
git checkout upstream/staging-next
nix-build --max-jobs 32 . -A peertube
# fails with EPIPE (tested two times)



git checkout staging-what
git diff upstream/staging-next
```diff

diff --git a/pkgs/tools/misc/coreutils/default.nix b/pkgs/tools/misc/coreutils/default.nix
index 16f3e4c7..fef8dbac 100644
--- a/pkgs/tools/misc/coreutils/default.nix
+++ b/pkgs/tools/misc/coreutils/default.nix
@@ -22,10 +22,10 @@ with lib;
 
 stdenv.mkDerivation (rec {
   pname = "coreutils";
-  version = "9.0";
+  version = "8.32";
 
   src = fetchurl {
-    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
+    url = "mirror://gnu/${pname}/${pname}-9.0.tar.xz";
     sha256 = "sha256-zjCs30pBvFuzDdlV6eqnX6IWtOPesIiJ7TJDPHs7l84=";
   };

```
nix-build --max-jobs 32 . -A peertube



























































Can somebody please tell me if https://github.com/NixOS/nixpkgs/compare/staging-next...mohe2015:staging-coreutils-regression should be an equivalent version?
And if yes check that the following builds peertube (which I think it shouldn't):
```
git clone --branch staging-coreutils-regression --depth 1 https://github.com/mohe2015/nixpkgs/
cd nixpkgs
nix-shell -p nixUnstable
nix-build --max-jobs 8 -A peertube
```

curl -LO https://ftp.gnu.org/gnu/coreutils/coreutils-9.0.tar.gz
mkdir coreutils
tar -xf coreutils-9.0.tar.gz -C coreutils
tar -h --mtime='1970-01-01 00:00:00 UTC' -cf file.tar coreutils
tar -xf file.tar coreutils -C coreutils

tar -h --mtime='1970-01-01 00:00:00 UTC' -cf coreutils-git.tar /etc/nixos/nixpkgs/source/
mkdir coreutils-git
tar -xf coreutils-git.tar -C coreutils-git


diffoscope --exclude-directory-metadata yes coreutils-git/etc/nixos/nixpkgs/source/ coreutils/coreutils-9.0/


nix-shell . -A coreutils
phases="$prePhases unpackPhase patchPhase $preConfigurePhases configurePhase $preBuildPhases" genericBuild
















git checkout upstream/staging-next
nix-shell -p nixUnstable
nix build --extra-experimental-features 'nix-command flakes' --out-link ../coreutils-staging-next .#coreutils

git checkout staging-coreutils-regression
nix --extra-experimental-features 'nix-command flakes' build --out-link ../coreutils-git .#coreutils




