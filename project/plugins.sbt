addSbtPlugin("org.scalameta" % "sbt-scalafmt" % "2.4.6")

// until https://github.com/scala/bug/issues/12632 is resolved
ThisBuild / libraryDependencySchemes ++= Seq(
  "org.scala-lang.modules" %% "scala-xml" % VersionScheme.Always
)
addSbtPlugin("com.github.sbt" % "sbt-native-packager" % "1.9.11")

addSbtPlugin("com.dwijnand" % "sbt-dynver" % "4.1.1")
