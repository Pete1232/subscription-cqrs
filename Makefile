PHONY: build check install

build:
	sbt compile

check:
	nixpkgs-fmt ./flake.nix --check

install:
	echo "install go here"
