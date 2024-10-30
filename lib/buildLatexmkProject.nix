{
  latexmk ? texlivePackages.latexmk,
  lib,
  mkLaTeXDerivation,
  texlivePackages,
  ...
}:
{
  extraOptions ? [ ],
  # The root filename(s) of LaTeX document(s)
  filename ? null,
  # A path to a local configuration file
  rcFile ? null,

  buildInputs ? [ ],
  ...
}@args:

let
  inherit (builtins) isNull;
  inherit (lib) optionalString;
  inherit (lib.strings) concatStringsSep escapeShellArg;

  latexmkOptions = [
    "--usepretex='\\pdfvariable suppressoptionalinfo 512\\relax'"
    "--interaction=nonstopmode"
    "--lualatex"
    "--pdflua"
    "--outdir=$out"
    (optionalString (!isNull rcFile) "-r \"${rcFile}\"")
  ] ++ extraOptions;
  latexmkOptsStrings = concatStringsSep " " latexmkOptions;

  cleanedArgs = removeAttrs args [
    "buildInputs"
    "extraOptions"
    "filename"
    "rcFile"
  ];
in
mkLaTeXDerivation (
  cleanedArgs
  // {
    buildInputs = buildInputs ++ [ latexmk ];

    buildPhaseLaTeXCommand =
      args.buildPhaseLaTeXCommand or # bash
      ''
        latexmk ${latexmkOptsStrings} ${escapeShellArg filename}
      '';
  }
)
