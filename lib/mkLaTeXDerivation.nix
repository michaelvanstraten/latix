{
  lib,
  pkgs,
  stdenvNoCC,
}:
{
  buildPhaseLaTeXCommand,
  fontPaths ? [ ],
  installPhaseCommand ? "",
  ...
}@args:
let
  inherit (builtins) removeAttrs;
  inherit (lib) optionalAttrs;

  cleanedArgs = removeAttrs args [
    "buildPhaseLaTeXCommand"
    "fontPaths"
    "installPhaseCommand"
  ];
in
stdenvNoCC.mkDerivation (
  cleanedArgs
  // optionalAttrs (fontPaths != [ ]) {
    OSFONTDIR = pkgs.symlinkJoin {
      name = "fonts";
      paths = fontPaths;
    };
  }
  // {
    TEXMFHOME = ".cache";
    TEXMFVAR = ".cache/texmf-var";

    buildPhase =
      args.buildPhase or ''
        runHook preBuild
        ${buildPhaseLaTeXCommand}
        runHook postBuild
      '';

    installPhase =
      args.installPhase or ''
        runHook preInstall
        ${installPhaseCommand}
        runHook postInstall
      '';
  }
)
