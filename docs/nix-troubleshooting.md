# nix troubleshooting

[nix development environment](https://nixos.wiki/wiki/Development_environment_with_nix-shell)

[nix build phases](https://nixos.org/manual/nixpkgs/stable/#sec-stdenv-phases)

[sbt derivation](https://github.com/zaninime/sbt-derivation)

[scala walkthrough](https://github.com/gvolpe/sbt-nix.g8#docker-images)

Any Nix files need to be staged in Git for them to be picked up

[nix develop --build and phases confusion](https://github.com/NixOS/nix/issues/6202)

[cachix](https://app.cachix.org/cache/pete1232)

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

The sbt-derivation sha will need to match that which is generated. If it doesn't an obscure error like this may be produced

```text
error: builder for '/nix/store/clgzs21q17cs4vh8i2pqwc5kv3q4krsh-subscription-cqrs-latest.drv' failed with exit code 1;
       last 10 log lines:
       > [error]       at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
       > [error]  at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:539)
       > [error]   at java.base/java.util.concurrent.FutureTask.run(FutureTask.java:264)
       > [error]  at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1136)
       > [error]   at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:635)
       > [error]   at java.base/java.lang.Thread.run(Thread.java:833)
       > [error] (core / Compile / compileIncremental) sbt.internal.inc.InvalidComponent: The compiler bridge sources CoursierModuleDescriptor(ModuleDescriptorConfiguration(false, None, org.scala-sbt.temp:temp-module-52f238aede5a1d8d7a484c2bec27a144810e2ac0:1.7.1:compile, ModuleInfo(temp-module-52f238aede5a1d8d7a484c2bec27a144810e2ac0, , None, None, Vector(), , None, None, Vector()), Vector(org.scala-sbt:compiler-bridge_2.13:1.7.1:compile), Vector(), Vector(), , Vector(compile, runtime, test, provided, optional), Some(compile), ConflictManager(latest-revision, *, *)),CoursierConfiguration(Some(sbt.internal.util.ManagedLogger@68c6b30a), Vector(FileRepository(local, Patterns(ivyPatterns=Vector(/build/tmp.J3nqy9o5xg/project/.ivy/local/[organisation]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)([branch]/)[revision]/[type]s/[artifact](-[classifier]).[ext]), artifactPatterns=Vector(/build/tmp.J3nqy9o5xg/project/.ivy/local/[organisation]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)([branch]/)[revision]/[type]s/[artifact](-[classifier]).[ext]), isMavenCompatible=false, descriptorOptional=false, skipConsistencyCheck=false), FileConfiguration(true, None)), public: https://repo1.maven.org/maven2/), 6, 100, Some(org.scala-lang), Some(2.12.16), Vector(/build/tmp.J3nqy9o5xg/project/.boot/scala-2.12.16/lib/scala-xml_2.12-1.0.6.jar, /build/tmp.J3nqy9o5xg/project/.boot/scala-2.12.16/lib/scala-reflect.jar, /build/tmp.J3nqy9o5xg/project/.boot/scala-2.12.16/lib/scala-library.jar, /build/tmp.J3nqy9o5xg/project/.boot/scala-2.12.16/lib/scala-compiler.jar), Vector(), Vector(), Vector(), true, false, Vector(), Vector(), Some(org.scala-lang), Some(2.13.8), Vector(), Vector(), Some(sbt.coursierint.LMCoursier$CoursierLogger@4539bdf2), Some(/build/tmp.J3nqy9o5xg/project/.coursier), Some(/build/tmp.J3nqy9o5xg/project/.ivy), None, None, Vector(), Vector(), Vector((ModuleMatchers(Set(), Set(), true),Relaxed)), true, 0, Some(24 hours), Vector(Some(SHA-1), None), Vector(LocalUpdateChanging, LocalOnly, Update), false, false, false, Vector())) could not be retrieved.
       > [error]
       > [error]  Note: Unresolved dependencies path:
       > [error] Total time: 1 s, completed Sep 24, 2022, 11:04:13 PM
```

Setting the sha to `""` will print out the correct value.

```text
warning: found empty hash, assuming 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
error: hash mismatch in fixed-output derivation '/nix/store/5xzg6f9ibyk3j1d2skvaxlmxqkx2p8g6-subscription-cqrs-sbt-dependencies.tar.zst.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-wq/R6AUrWP3ZUtTefbMXSfJA7R2bTHZLy9Pfj8lG3vM=
```

If any of:

- nixpkgs
- sbt-derivation
- project dependencies

are updated then the sha-256 will need to be updated. The build derivation should be cached so it doesn't need to be rebuilt as often.
