{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  elmexport = haskellPackages.callPackage ../../elm-export {};

  f = { mkDerivation, base, elm-export, stdenv }:
      mkDerivation {
        pname = "common";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        executableHaskellDepends = [ base elmexport ];
        description = "Common types shared between ghcjs and Elm";
        license = stdenv.lib.licenses.unfree;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
