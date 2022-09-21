{
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.sbt-derivation = {
    url = "github:zaninime/sbt-derivation";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.gitignore = {
    url = "github:hercules-ci/gitignore.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, sbt-derivation, gitignore }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (final: prev: { jre = prev.jdk11_headless; })
            (final: prev: { sbt = prev.sbt.override { jre = prev.jdk11_headless; }; })
          ];
        };
        inherit (gitignore.lib) gitignoreSource;

        version = "0.0.1"; # TODO use jar version? or just a variable
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
          version = version;
          src = gitignoreSource self;
          pkgs = pkgs;
          depsSha256 = "2TATAfxWnRhu3CKPl8xy+1PMNwAgWi8bNp/aCT/fcYU=";

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
            copyToRoot = [ core pkgs.adoptopenjdk-jre-openj9-bin-11 ];

            config = {
              Cmd = [ "java" "-jar" "subscription-cqrs-assembly-core.jar" ];
            };
          };
      });
}
