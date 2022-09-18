{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells = {
          default =
            pkgs.mkShell {
              pname = "subscription-cqrs";
              version = "0.0.1";

              buildInputs = [ pkgs.mill pkgs.nixpkgs-fmt ];
              buildPhase = ''
                mill _.compile
              '';
              checkPhase = ''
                nixpkgs-fmt ./flake.nix --check
              '';
            };
        };
      });
}
