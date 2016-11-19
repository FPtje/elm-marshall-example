{ pkgs            ? import <nixpkgs> {},
  stdenv          ? pkgs.stdenv,
  mkDerivation    ? stdenv.mkDerivation,
  callPackage     ? pkgs.callPackage,
  runCommand      ? pkgs.runCommand
}:
let
  # The haskell package that generates the common types
  common = callPackage ./common {};

  # The Elm file generated by common
  common-elm = runCommand "Types.elm" {} ''
    ${common}/bin/common
    cp Types.elm $out
  '';

  # ghcjs compiled common library (the other one is plain ghc)
  common-ghcjs = pkgs.haskell.packages.ghcjs.callPackage ./common { compiler = "ghcjs"; };

  elm-side = callPackage ./elm { inherit common-elm; };

  ghcjs-side = pkgs.haskell.packages.ghcjs.callPackage ./ghcjs { inherit common-ghcjs; };

  # The final derivation
  drv = mkDerivation {
    name = "elm-marshall-helloworld";

    phases = [ "buildPhase" ];
    src = ./.;

    # Home is set because of this bug:
    # https://github.com/elm-lang/elm-make/issues/93
    buildPhase = ''
      mkdir $out

      cp ${elm-side}/main.js $out/
      cp -r ${./static}/* $out/
      cp ${ghcjs-side}/bin/elm-marshall.jsexe/all.js $out/ghcjs.js
    '';
  };
in
drv
# if pkgs.lib.inNixShell then drv.env else drv