{
mkDerivation,
base,
common-ghcjs,
ghcjs-base,
ghcjs-dom,
ghcjs-ffiqq,
stdenv
}:
mkDerivation {
  pname = "elm-marshall";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    common-ghcjs

    base
    ghcjs-base
    ghcjs-dom
    ghcjs-ffiqq
  ];
  description = "Ghcjs part of the elm-marshall example";
  license = stdenv.lib.licenses.gpl2;
}
