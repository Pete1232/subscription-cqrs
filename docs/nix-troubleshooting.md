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

## Cachix debugging

[test build](https://github.com/Pete1232/subscription-cqrs/actions/runs/3165661727), will eventually be deleted

Initial build 4m20s

Re-running an identical build outputs the following:

```text
 this path will be fetched (196.28 MiB download, 198.59 MiB unpacked):
  /nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz
copying path '/nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz' from 'https://pete1232.cachix.org'...
```

Finished in 35s

No point caching that though - it won't be common to re-build the exact same derivation. Deleting the completed image in the cache logs this instead:

```text
 this path will be fetched (196.28 MiB download, 198.59 MiB unpacked):
  /nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz
copying path '/nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz' from 'https://pete1232.cachix.org'...
```

Finished in 1m29s

Same issue. This docker image is going to change every time, so no point caching

Making a code change to see what needs to be re-generated.

Before:

```text
/nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz 196.27 MiB 198.58 MiB 2022-10-01T18:32:08.780Z 
/nix/store/sbqmyyaqyk5s4zmnjznxbijhidpji211-subscription-cqrs-sbt-dependencies.tar.zst 80.72 MiB 81.82 MiB 2022-10-01T17:59:11.017Z 
/nix/store/7w25gp6695hdrjndixgysdpchvy7gymb-docker-layer-subscription-cqrs 17.64 MiB 51.07 MiB 2022-10-01T18:22:58.871Z 
/nix/store/d2ram0dar3wayqkricw4smq9zp5nwkfc-sbt-1.6.2 15.98 MiB 50.7 MiB 2022-10-01T18:26:16.703Z 
/nix/store/g15mknl2gj2fbimh6wj54sh5yv19crlr-subscription-cqrs-latest 5.28 MiB 5.71 MiB never 
/nix/store/bsaji0zhqa37l91x85rkqa78v7jv1vcl-runtime-deps 5.22 KiB 9.17 KiB never 
/nix/store/6l0wninl4kkcg7aid41x9l36xr7f3snf-scalafmt-3.4.3 748 B 3.91 KiB 2022-10-01T18:26:16.706Z 
/nix/store/w5wzqrd1x1zpk5486i5yxy86r27faq9r-extract-dependencies 672 B 912 B never 
/nix/store/j55gbrx5wjhqd5205999n7zn4qaqlwqz-subscription-cqrs-config.json 252 B 256 B never
```

Logs, show what was re-used:

```text
copying path '/nix/store/sbqmyyaqyk5s4zmnjznxbijhidpji211-subscription-cqrs-sbt-dependencies.tar.zst' from 'https://pete1232.cachix.org'...
...
copying path '/nix/store/d2ram0dar3wayqkricw4smq9zp5nwkfc-sbt-1.6.2' from 'https://pete1232.cachix.org'...
copying path '/nix/store/6l0wninl4kkcg7aid41x9l36xr7f3snf-scalafmt-3.4.3' from 'https://pete1232.cachix.org'...
```

After:

```text
/nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz 196.27 MiB 198.58 MiB 2022-10-01T18:32:08.780Z 
/nix/store/yvfnpimk2bcfbp51pw1a2h0n5j3a1v23-docker-image-subscription-cqrs.tar.gz 196.27 MiB 198.58 MiB never 
/nix/store/sbqmyyaqyk5s4zmnjznxbijhidpji211-subscription-cqrs-sbt-dependencies.tar.zst 80.72 MiB 81.82 MiB 2022-10-01T18:40:43.087Z 
/nix/store/mg0g8pzly1vzkv3lsd1p49livglx374b-docker-layer-subscription-cqrs 17.64 MiB 51.07 MiB never 
/nix/store/7w25gp6695hdrjndixgysdpchvy7gymb-docker-layer-subscription-cqrs 17.64 MiB 51.07 MiB 2022-10-01T18:22:58.871Z 
/nix/store/d2ram0dar3wayqkricw4smq9zp5nwkfc-sbt-1.6.2 15.98 MiB 50.7 MiB 2022-10-01T18:40:43.092Z 
/nix/store/3l5p18p1dcf0rg67hi6fbcfzlasdjiyv-subscription-cqrs-latest 5.28 MiB 5.71 MiB never 
/nix/store/g15mknl2gj2fbimh6wj54sh5yv19crlr-subscription-cqrs-latest 5.28 MiB 5.71 MiB never 
/nix/store/1gxir0rvy5nc5f3x8zxh1svwfjyl2y65-runtime-deps 5.22 KiB 9.17 KiB never 
/nix/store/bsaji0zhqa37l91x85rkqa78v7jv1vcl-runtime-deps 5.22 KiB 9.17 KiB never 
/nix/store/6l0wninl4kkcg7aid41x9l36xr7f3snf-scalafmt-3.4.3 748 B 3.91 KiB 2022-10-01T18:40:43.128Z 
/nix/store/w5wzqrd1x1zpk5486i5yxy86r27faq9r-extract-dependencies 672 B 912 B never 
/nix/store/j55gbrx5wjhqd5205999n7zn4qaqlwqz-subscription-cqrs-config.json 252 B 256 B never
```

So TL;DR is that the `sbt-dependencies` derivation _is_ definitely re-used as long as the dependencies are unchanged, and is therefore worth caching.

The docker layers and images are _not_ reused if the code changes.

Don't cache:

```text
/nix/store/klpcqjmd184slrli4xhc020cmzmpjdkk-docker-image-subscription-cqrs.tar.gz
/nix/store/7w25gp6695hdrjndixgysdpchvy7gymb-docker-layer-subscription-cqrs
/nix/store/g15mknl2gj2fbimh6wj54sh5yv19crlr-subscription-cqrs-latest
/nix/store/bsaji0zhqa37l91x85rkqa78v7jv1vcl-runtime-deps
```

Cache:

```text
/nix/store/sbqmyyaqyk5s4zmnjznxbijhidpji211-subscription-cqrs-sbt-dependencies.tar.zst
/nix/store/d2ram0dar3wayqkricw4smq9zp5nwkfc-sbt-1.6.2
/nix/store/6l0wninl4kkcg7aid41x9l36xr7f3snf-scalafmt-3.4.3
/nix/store/w5wzqrd1x1zpk5486i5yxy86r27faq9r-extract-dependencies
/nix/store/j55gbrx5wjhqd5205999n7zn4qaqlwqz-subscription-cqrs-config.json
```

`pushFilter` Regex:

```text
(-source$|.*docker.*$|.*subscription-cqrs-latest$|.*runtime-deps$)
```

But... the last two aren't pushed each time - but also aren't used. So lets not cache those either.

```text
(-source$|.*docker.*$|.*subscription-cqrs-latest$|.*runtime-deps$|.*extract-dependencies$|.*config.json$)
```
