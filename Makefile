.PHONY: build check

build:
	mill core.compile

check:
	nixpkgs-fmt ./flake.nix --check
