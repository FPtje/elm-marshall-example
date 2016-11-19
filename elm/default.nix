{pkgs ? import <nixpkgs> {}, stdenv ? pkgs.stdenv, common-elm ? ""}:
let
  nixpkgs = import (pkgs.fetchgit {
    url = "https://github.com/NixOS/nixpkgs.git";
    rev = "80cbb8acf17cd128e834d4a11f8270b9a5197166";
    sha256 = "0phbszg02rrr1d34966piljd9i5di22g89q1dvmm4w1gajjrimqp";
  }) {};

  drv = nixpkgs.stdenv.mkDerivation {
    name = "elm-helloworld";
    buildInputs = with nixpkgs.elmPackages; [ elm-compiler elm-make elm-package elm-reactor nixpkgs.tree ];

    phases = [ "unpackPhase" "buildPhase" ];
    src = ./.;

    # Home is set because of this bug:
    # https://github.com/elm-lang/elm-make/issues/93
    buildPhase = ''
      cp ${common-elm} src/Types.elm

      HOME=$out
      
      elm make src/main.elm --output=$out/main.js --yes
    '';
  };
in
drv
# if pkgs.lib.inNixShell then drv.env else drv
