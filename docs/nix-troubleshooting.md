# nix troubleshooting

[nix development environment](https://nixos.wiki/wiki/Development_environment_with_nix-shell)

[nix build phases](https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases)

[sbt derivation](https://github.com/zaninime/sbt-derivation)

[scala walkthrough](https://github.com/gvolpe/sbt-nix.g8#docker-images)

Any Nix files need to be staged in Git for them to be picked up

[nix develop --build and phases confusion](https://github.com/NixOS/nix/issues/6202)

The scalafmt config version must match the installed version. If not it will have to download config and will fail.

```text
error: builder for '/nix/store/jbrxzplj7dfpr0kad55link3bygnnmrx-subscription-cqrs-latest.drv' failed with exit code 8;
       last 10 log lines:
       >       at org.scalafmt.dynamic.ScalafmtConfigLoader$CachedProxy.load(ScalafmtConfigLoader.scala:70)
       >   at org.scalafmt.dynamic.ScalafmtDynamic.resolveConfig(ScalafmtDynamic.scala:53)
       >        at org.scalafmt.dynamic.ScalafmtDynamic.createSession(ScalafmtDynamic.scala:47)
       >        at org.scalafmt.cli.ScalafmtDynamicRunner$.run(ScalafmtDynamicRunner.scala:29)
       >         at org.scalafmt.cli.Cli$.runWithRunner(Cli.scala:140)
       >  at org.scalafmt.cli.Cli$.run(Cli.scala:91)
       >     at org.scalafmt.cli.Cli$.mainWithOptions(Cli.scala:61)
       >         at org.scalafmt.cli.Cli$.main(Cli.scala:43)
       >    at org.scalafmt.cli.Cli.main(Cli.scala)
       > error: UnexpectedError=8
```

The sbt-derivation sha will need to match. Setting it to `""` will print out the correct value.

```text
warning: found empty hash, assuming 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
error: hash mismatch in fixed-output derivation '/nix/store/5xzg6f9ibyk3j1d2skvaxlmxqkx2p8g6-subscription-cqrs-sbt-dependencies.tar.zst.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-wq/R6AUrWP3ZUtTefbMXSfJA7R2bTHZLy9Pfj8lG3vM=
```
