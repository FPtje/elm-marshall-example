{pkgs, stdenv ? pkgs.stdenv, common-elm ? ""}:
let
  drv = pkgs.stdenv.mkDerivation {
    name = "elm-helloworld";
    buildInputs = with pkgs.elmPackages; [ elm-compiler elm-make elm-package elm-reactor pkgs.tree ];

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
