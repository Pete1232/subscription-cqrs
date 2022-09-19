# subscription-cqrs

## tools

### nix

Start a nix shell with

```sh
nix develop -i
```

To run the full build

```sh
nix develop -i
> genericBuild
```

or as it runs in CI (make sure to delete all /target directories if running locally, and can still be flaky)

```sh
nix build
```

[nix development environment](https://nixos.wiki/wiki/Development_environment_with_nix-shell)

[nix build phases](https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases)

[sbt derivation](https://github.com/zaninime/sbt-derivation)

[scala walkthrough](https://github.com/gvolpe/sbt-nix.g8#docker-images)

#### Notes

- Any Nix files need to be staged in Git for them to be picked up
- [nix develop --build and phases confusion](https://github.com/NixOS/nix/issues/6202)
- The scalafmt config version must match the instal;ed version. If not it will have to download config and will fail.
