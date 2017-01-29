{
mkDerivation,
base,
common-ghcjs,
elm-marshall,
ghcjs-base,
ghcjs-dom,
ghcjs-ffiqq,
stdenv
}:
mkDerivation {
  pname = "elm-marshall-example-ghcjs";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    common-ghcjs

    base
    elm-marshall
    ghcjs-base
    ghcjs-dom
    ghcjs-ffiqq
  ];
  description = "Ghcjs part of the elm-marshall example";
  license = stdenv.lib.licenses.gpl2;
}
