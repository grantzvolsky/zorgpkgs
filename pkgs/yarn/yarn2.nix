{ lib, stdenv, nodejs, fetchgit }:

stdenv.mkDerivation rec {
  pname = "yarn";
  version = "2.4.1";

  src = fetchgit {
    url = "https://github.com/yarnpkg/berry";
    rev = "@yarnpkg/cli/2.4.1";
    sha256 = "10mn9wihil0h22yykyk6bja0cazd1gcv9n2cr8s5s9dgiv2c9np5";
  };

  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/yarn/}
    cp -R . $out/libexec/yarn
    chmod +x $out/libexec/yarn/packages/yarnpkg-cli/bin/yarn.js
    ln -s $out/libexec/yarn/packages/yarnpkg-cli/bin/yarn.js $out/bin/yarn
    ln -s $out/libexec/yarn/packages/yarnpkg-cli/bin/yarn.js $out/bin/yarnpkg
  '';

  meta = with lib; {
    homepage = "https://yarnpkg.com/";
    description = "Yarn 2 builder based on https://github.com/NixOS/nixpkgs/blob/0d337eb6b77c8911cd02ed92e63fcc2a8949b404/pkgs/development/tools/yarn/default.nix";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
