{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils/c0e246b9b83f637f4681389ecabcb2681b4f3af0";
  inputs.sbt-derivation = {
    url = "github:zaninime/sbt-derivation/fe0044d2cd351f4d6257956cde3a2ef633d33616";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.gitignore = {
    url = "github:hercules-ci/gitignore.nix/a20de23b925fd8264fd7fad6454652e142fd7f73";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, sbt-derivation, gitignore }:
    let
      inherit (flake-utils.lib) eachSystem system;
      inherit (gitignore.lib) gitignoreSource;
    in
    eachSystem
      ([
        system.aarch64-linux
        system.x86_64-darwin
        system.x86_64-linux
      ])
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              (final: prev: { jre = prev.jdk17_headless; })
              (final: prev: { sbt = prev.sbt.override { jre = prev.jdk17_headless; }; })
            ];
          };

          build = ''
            nixpkgs-fmt ./flake.nix --check;
            scalafmt --exclude project/metals.sbt --exclude .metals --exclude target --test
            sbt ";test;core/assembly";
          '';
          install = ''
            mkdir -p $out
            cp core/target/scala-*/*-assembly-*.jar $out
          '';

          core = sbt-derivation.lib.mkSbtDerivation {
            pname = "subscription-cqrs";
            version = "latest";
            src = gitignoreSource self;
            pkgs = pkgs;
            depsSha256 = "vkuqAoMcqf6vBr5PlgGdVDKFzvXqUBPt0zCrXORpiLw=";

            nativeBuildInputs = [ pkgs.nixpkgs-fmt pkgs.scalafmt ];

            buildPhase = build;
            installPhase = install;
          };
        in
        {
          devShells.default =
            pkgs.mkShell {
              buildInputs = [ pkgs.sbt pkgs.nixpkgs-fmt pkgs.scalafmt ];

              buildPhase = build;
              installPhase = install;
            };

          packages.default =
            pkgs.dockerTools.buildImage {
              name = core.pname;
              tag = core.version;
              contents = [ core pkgs.jre_minimal ];

              config = {
                Cmd = [ "java" "-jar" "subscription-cqrs-assembly-core.jar" ];
              };
            };
        });
}
