{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.sbt.url = "github:zaninime/sbt-derivation";
  inputs.sbt.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, sbt }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { jre = prev.jdk11_headless; })
          ];
        };
      in
      {
        devShells = {
          default =
            pkgs.mkShell {
              buildInputs = [ pkgs.sbt pkgs.nixpkgs-fmt ];
            };
        };
      });
}
