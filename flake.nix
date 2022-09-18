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
            (final: prev: { jre = prev.jdk17_headless; })
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

        defaultPackage =
          sbt.mkSbtDerivation.${system} {
            depsSha256 = "Vjkbb73ZglQoGOsv7uNXeuJcf5asySmjTJX3I1eqzsE=";

            pname = "subscription-cqrs";
            version = "0.0.1";
            src = self;

            nativeBuildInputs = [ pkgs.nixpkgs-fmt ];
          };
      });
}
