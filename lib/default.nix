{
  lib,
  newScope,
}:
lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    mkLaTeXDerivation = callPackage ./mkLaTeXDerivation.nix { };
    buildLatexmkProject = callPackage ./buildLatexmkProject.nix { };
  }
)
