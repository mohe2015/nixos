﻿# close old terminal window
cd /etc/nixos/nixpkgs
git checkout f85c9264e64cf77440ffde1beb646bde614be343
rm -f result
sudo nix-collect-garbage # I'm lazy (and don't know how to pin dependencies), sorry to the binary cache
#nix develop .#esbuild # get dependencies
#exit
#nix build --keep-outputs --debug --option substitute false -L .#esbuild


git checkout f85c9264e64cf77440ffde1beb646bde614be343

nix build --option substitute false .#esbuild

nix-store --delete /nix/store/09d91l464srbdx1dsgj1yhfichyck8d5-esbuild-0.12.17-go-modules.drv /nix/store/hxr5n64r9i1ngg1ll0gq2whm21sk22bw-esbuild-0.12.17



Vladimír Čunát: While sleeping over it I think the miscompilation for peertube may not actually have anything to do with coreutils. As I looked at the diff and didn't see anything out of the ordinary I think the following could also be possible: When the coreutils derivation hash changes all dependent hashes change so all -frandom-seed's change too. If you still have the build products and have the time you could diffoscope the outputs of golang, yarn, esbuild_locked (oh this is annoying as its not an own attr), nodejs-16_x, nodejs-14_x

git clone git://git.sv.gnu.org/coreutils /tmp/coreutils
cd /tmp/coreutils
git checkout v9.0
git submodule init
git submodule update --recursive
git revert a6eaee501f6ec0c152abe88640203a64c390993e









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
nix-build --max-jobs 32 . -A coreutils
/nix/store/pb05l5rvhczgm7jqjy06rh34n8krk93j-coreutils-9.0


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
/nix/store/fydqiz1z0mx2fmrfawzhi4sxjyvcwfaz-peertube-3.4.1
nix-build --max-jobs 32 . -A coreutils
/nix/store/b9lhc3wk7wlcsngr9kwfy6nv84sbfv14-coreutils-8.32


diffoscope /nix/store/pb05l5rvhczgm7jqjy06rh34n8krk93j-coreutils-9.0 /nix/store/b9lhc3wk7wlcsngr9kwfy6nv84sbfv14-coreutils-8.32






















































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



