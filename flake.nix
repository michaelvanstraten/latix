{
  description = "Deterministic LaTeX compilation with Nix ";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      flake-utils,
      nixpkgs,
      pre-commit-hooks,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        lib = import ./lib { inherit (pkgs) lib newScope; };

        formatter = pkgs.nixfmt-rfc-style;

        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nil.enable = true;
              nixfmt-rfc-style.enable = true;
              prettier = {
                enable = true;
                settings = {
                  prose-wrap = "always";
                };
              };
            };
          };
        };
      }
    );
}
