{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.sbt-derivation.url = "github:zaninime/sbt-derivation";
  inputs.sbt-derivation.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, sbt-derivation }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { jre = prev.jdk11_headless; })
            (final: prev: { sbt = prev.sbt.override { jre = prev.jdk11_headless; }; })
          ];
        };
      in
      {
        devShells.default =
          pkgs.mkShell {
            buildInputs = [ pkgs.docker pkgs.sbt pkgs.nixpkgs-fmt ];
          };

        packages.default =
          sbt-derivation.lib.mkSbtDerivation {
            pname = "subscription-cqrs";
            version = "0.0.1";
            src = self;
            pkgs = pkgs;
            depsSha256 = "RWapFTsH3oy48EA0FaCVoAU1gSUKR9MeiC9xKv9sQPI=";

            nativeBuildInputs = [ pkgs.nixpkgs-fmt ];
          };
      });
}
