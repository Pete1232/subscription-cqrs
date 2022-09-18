PHONY: build check

build:
	sbt compile

check:
	nixpkgs-fmt ./flake.nix --check
